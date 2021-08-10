apt_update 'update'

apache2_install 'default_install' do
  server_signature 'On'
  server_tokens 'Minimal'
  trace_enable 'On'
  default_charset 'utf-8'
  envvars_additional_params(
    FOO: 'bar'
  )
end

apache2_site '000-default' do
  action :disable
end

apache2_default_site '' do
  action :enable
end

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action :nothing
end
