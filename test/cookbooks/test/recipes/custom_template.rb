apt_update 'update'

apache2_install 'default_install' do
  template_cookbook 'test'
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

apache2_conf 'custom' do
  template_cookbook 'test'
  options(
    index_ignore: '. .secret *.gen',
    index_charset: 'UTF-8'
  )
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action %i(enable start)
end
