apt_update 'update'

apache2_install 'default_install' do
  listen '8080'
  notifies :restart, 'apache2_service[default]'
end

apache2_service 'default' do
  action %i(enable start)
end
