property :template, String,
         default: 'web_app.conf.erb',
         description: 'Template name'
property :cookbook, String,
         default: 'apache2',
         description: 'Cookbok to source the template from'
property :local, [true, false],
          default: false,
          description: 'Load a template from a local path. By default, the chef-client
loads templates from a cookbook’s /templates directory. When this property is
set to true, use the source property to specify the path to a template on the
local node.'
property :local, [true, false],
         default: false,
         description: ''
property :enable, [true, false],
         default: true,
         description: 'enable or disable the site'
property :server_port, Integer,
         default: 80,
         description: 'Port to listen on'
property :root_group, String,
default: lazy { default_apache_root_group },
description: ''
property :parameters, Hash,
description: ''

action :enable do
  apache2_module 'rewrite'

  apache2_module 'deflate'

  apache2_module 'headers' do
    apache_service_notification :restart
  end

  template "#{apache_dir}/sites-available/#{new_resource.name}.conf" do
    source new_resource.template
    local new_resource.local
    cookbook 'apache2'
    owner 'root'
    group new_resource.root_group
    mode '0644'
    cookbook new_resource.cookbook
    variables(
      name: new_resource.name,
      params: new_resource.params
    )
    if ::File.exist?("#{apache_dir}/sites-enabled/#{new_resource.name}.conf")
      notifies :reload, 'service[apache2]', :delayed
    end
  end

  apache2_site new_resource.name
end
