apache2_install 'default' do
  mpm 'prefork'
  notifies :restart, 'apache2_service[default]'
end

apache2_mod_auth_cas 'default' do
  directives(
    'CASCookiePath' => "#{cache_dir}/mod_auth_cas/"
  )
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action %i(enable start)
end
