apt_update 'update'

apache2_install 'default_install' do
  template_cookbook 'test'
end

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action :nothing
end

apache2_site '000-default' do
  action :disable
end

apache2_default_site '' do
  action :enable
end

apache2_conf 'custom' do
  template_cookbook 'test'
  options(
    index_ignore: '. .secret *.gen',
    index_charset: 'UTF-8'
  )
end


# /etc/apache2/conf-enabled/custom.conf
# /etc/httpd/conf-available/custom.conf
