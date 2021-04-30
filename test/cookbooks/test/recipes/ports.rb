apt_update 'update'

apache2_install 'default_install' do
  listen '8080'
end

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action :nothing
end
