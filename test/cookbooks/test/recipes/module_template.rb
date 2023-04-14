apache2_install 'default' do
  notifies :restart, 'apache2_service[default]'
end

apache2_module 'info' do
  conf true
  template_cookbook 'test'
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action %i(enable start)
end
