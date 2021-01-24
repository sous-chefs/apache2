unified_mode true

property :path, String,
         default: lazy { "#{apache_dir}/conf-available" },
         description: 'Path to the conf-available directory'

property :root_group, String,
         default: lazy { node['root_group'] },
         description: ''

property :template_cookbook, String,
         default: 'apache2',
         description: 'Cookbook to source the template from. Override this to provide your own template'

property :options, Hash,
         default: {
           server_tokens: 'Prod',
           server_signature: 'On',
           trace_enable: 'Off',
         },
         description: 'A hash to pass to the template'

action :enable do
  template ::File.join(new_resource.path, "#{new_resource.name}.conf") do
    cookbook new_resource.template_cookbook
    owner 'root'
    group new_resource.root_group
    backup false
    mode '0644'
    variables new_resource.options.merge({ apache_dir: apache_dir })
    notifies :restart, 'service[apache2]', :delayed
  end

  execute "a2enconf #{new_resource.name}" do
    command "/usr/sbin/a2enconf #{new_resource.name}"
    notifies :restart, 'service[apache2]', :delayed
    not_if { conf_enabled?(new_resource) }
  end
end

action :disable do
  execute "a2disconf #{new_resource.name}" do
    command "/usr/sbin/a2disconf #{new_resource.name}"
    notifies :reload, 'service[apache2]', :delayed
    only_if { conf_enabled?(new_resource) }
  end
end
