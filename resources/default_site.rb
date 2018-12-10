property :default_site_name, String,
         default: 'default-site',
         description: 'The default site name'

property :site_action, [String, Symbol],
         default: :enable,
         coerce: proc { |m| m.is_a?(String) ? m.to_i : m },
         equal_to: %i( enable disable),
         description: 'Enable the site. Allows you to place all the configuration on disk but not enable the site.'

property :port, String,
         default: '80',
         description: 'Listen port'

property :cookbook, String,
         default: 'apache2',
         description: 'Cookbook to source the template file from'

property :server_admin, String,
         default: 'root@localhost',
         description: 'Default site contact name'

property :log_level, String,
         default: 'warn',
         description: 'log level for apache2'

action :enable do

  template "#{new_resource.default_site_name}.conf" do
    path "#{apache_dir}/sites-available/#{new_resource.default_site_name}.conf"
    source 'default-site.conf.erb'
    owner 'root'
    group default_apache_root_group
    mode '0644'
    cookbook new_resource.cookbook

    variables(
      server_admin: new_resource.server_admin,
      port: new_resource.port,
      docroot_dir: default_docroot_dir,
      cgibin_dir: default_cgibin_dir,
      error_log: default_error_log,
      access_log: default_access_log,
      log_dir: default_log_dir,
      log_level: new_resource.log_level
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
    group apache_root_group
    mode '0644'
    cookbook new_resource.cookbook
    action :delete
  end

  %w(default default.conf 000-default 000-default.conf).each do |site|
    link "#{apache_dir}/sites-enabled/#{site}" do
      action :delete
    end

    file "#{apache_dir}/sites-available/#{site}" do
      action :delete
      backup false
    end
  end

  apache2_site new_resource.default_site_name do
    action :disable
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
