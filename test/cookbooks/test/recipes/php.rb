::Chef::Recipe.include Apache2::Cookbook::Helpers

directory 'purge distro conf.modules.d' do
  extend Apache2::Cookbook::Helpers
  path "#{apache_dir}/conf.modules.d"
  recursive true
  action :nothing # trigger this in other resources as needed
end

directory 'purge distro conf.d' do
  extend Apache2::Cookbook::Helpers
  path "#{apache_dir}/conf.d"
  recursive true
  action :nothing # trigger this in other resources as needed
end

apache2_install 'default' do
  mpm 'prefork'
end

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_mod_php '' do
  notifies :delete, 'directory[purge distro conf.modules.d]'
  notifies :delete, 'directory[purge distro conf.d]'
end

file "#{default_docroot_dir}/info.php" do
  content "<?php\nphpinfo();\n?>"
end

apache2_default_site 'php_test'

package 'curl' if platform?('debian')
