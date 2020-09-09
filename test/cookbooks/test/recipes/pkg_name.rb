include_recipe 'yum-ius'

apache2_install 'default_install' do
  apache_pkg 'httpd24u'
end

apache2_site '000-default' do
  action :disable
end

apache2_default_site '' do
  action :enable
end

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action :nothing
end

apache2_module 'ssl' do
  mod_conf(
    mod_ssl_pkg: 'httpd24u-mod_ssl'
  )
end

apache2_mod_ssl ''
