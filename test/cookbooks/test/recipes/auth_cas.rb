extend Apache2::Cookbook::Helpers

apt_update 'update'

apache2_install 'default' do
  mpm 'prefork'
  notifies :restart, 'apache2_service[default]'
end

apache2_mod_auth_cas 'default' do
  # Exercise the EPEL package path on RHEL; SUSE uses its supported source default.
  install_method 'package' if platform_family?('rhel')
  directives(
    'CASCookiePath' => "#{cache_dir}/mod_auth_cas/"
  )
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action %i(enable start)
end
