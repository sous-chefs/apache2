apt_update 'update'

apache2_install 'default_install' do
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
