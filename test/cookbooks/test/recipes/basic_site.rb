apache2_install 'default' do
  notifies :restart, 'apache2_service[default]'
end

apache2_module 'deflate' do
  notifies :reload, 'apache2_service[default]'
end

apache2_module 'headers' do
  notifies :reload, 'apache2_service[default]'
end

app_dir = '/var/www/basic_site'

directory app_dir do
  recursive true
  owner lazy { default_apache_user }
  group lazy { default_apache_group }
end

file "#{app_dir}/index.html" do
  content 'Hello World'
  owner   lazy { default_apache_user }
  group   lazy { default_apache_group }
end

apache2_default_site 'basic_site' do
  default_site_name 'basic_site'
  template_cookbook 'test'
  template_source 'basic_site.conf.erb'
  variables(
    server_name: '127.0.0.1',
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    site_name: 'basic_site'
  )
  notifies :reload, 'apache2_service[default]'
end

apache2_default_site 'disabled_site' do
  default_site_name 'disabled_site'
  site_action :disable
  template_cookbook 'test'
  template_source 'basic_site.conf.erb'
  variables(
    server_name: '127.0.0.1',
    document_root: app_dir,
    log_dir: lazy { default_log_dir }
  )
  notifies :reload, 'apache2_service[default]'
end

apache2_site '000-default' do
  action :disable
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action %i(enable start)
end
