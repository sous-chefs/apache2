apache2_install 'default'

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_module 'deflate'
apache2_module 'headers'

app_dir = '/var/www/basic_site'

directory app_dir do
  recursive true
end

file "#{app_dir}/index.html" do
  content 'Hello World'
  extend  Apache2::Cookbook::Helpers
  owner   lazy { default_apache_user }
  group   lazy { default_apache_group }
end

template 'basic_site' do
  extend  Apache2::Cookbook::Helpers
  source 'basic_site.conf.erb'
  path "#{apache_dir}/sites-available/basic_site.conf"
  variables(
    server_name: '127.0.0.1',
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    site_name: 'basic_site'
  )
end

apache2_site 'basic_site'

apache2_site '000-default' do
  action :disable
end
