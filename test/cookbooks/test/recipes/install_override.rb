apt_update 'update'

apache2_install 'default_install' do
  server_signature 'On'
  server_tokens 'Minimal'
  trace_enable 'On'
  default_charset 'utf-8'
  envvars_additional_params(
    FOO: 'bar'
  ) if platform_family?('debian')
  sysconfig_additional_params(
    FOO: 'bar'
  ) if platform_family?('rhel', 'amazon', 'fedora', 'suse')
  notifies :restart, 'apache2_service[default]'
end

apache2_site '000-default' do
  action :disable
  notifies :reload, 'apache2_service[default]'
end

apache2_default_site '' do
  action :enable
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action %i(enable start)
end
