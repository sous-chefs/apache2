unified_mode true

property :default_site_name, String,
         default: 'default-site',
         description: 'The default site name'

property :site_action, [String, Symbol],
         default: :enable,
         coerce: proc { |m| m.is_a?(String) ? m.to_i : m },
         equal_to: %i( enable disable),
         description: 'Enable the site. Allows you to place all the configuration on disk but not enable the site'

property :port, String,
         default: '80',
         description: 'Listen port'

property :template_cookbook, String,
         default: 'apache2',
         description: 'Cookbook to source the template file from'

property :server_admin, String,
         default: 'root@localhost',
         description: 'Default site contact name'

property :log_level, String,
         default: 'warn',
         description: 'Log level for apache2'

property :log_dir, String,
         default: lazy { default_log_dir },
         description: 'Default Apache2 log directory'

property :docroot_dir, String,
         default: lazy { default_docroot_dir },
         description: 'Apache document root.'\
'Defaults to platform specific locations, see libraries/helpers.rb'

property :apache_root_group, String,
         default: lazy { node['root_group'] },
         description: 'Group that the root user on the box runs as.'\
'Defaults to platform specific locations, see libraries/helpers.rb'

property :template_source, String,
         default: lazy { default_site_template_source },
         description: 'Source for the template.'\
'defaults to #{new_resource.default_site_name}.conf on Debian flavours and welcome.conf on all other platforms'

action :enable do
  template "#{new_resource.default_site_name}.conf" do
    source new_resource.template_source
    path "#{apache_dir}/sites-available/#{new_resource.default_site_name}.conf"
    owner 'root'
    group new_resource.apache_root_group
    mode '0644'
    cookbook new_resource.template_cookbook
    variables(
      access_log: default_access_log,
      cgibin_dir: default_cgibin_dir,
      docroot_dir: new_resource.docroot_dir,
      error_log: default_error_log,
      log_dir: default_log_dir,
      log_level: new_resource.log_level,
      port: new_resource.port,
      server_admin: new_resource.server_admin
    )
  end

  apache2_site new_resource.default_site_name do
    action :enable
  end
end

action :disable do
  template "#{new_resource.default_site_name}.conf" do
    path "#{apache_dir}/sites-available/#{new_resource.default_site_name}.conf"
    source 'default-site.conf.erb'
    owner 'root'
    group new_resource.apache_root_group
    mode '0644'
    cookbook new_resource.template_cookbook
    action :delete
  end

  apache2_site new_resource.default_site_name do
    action :disable
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
