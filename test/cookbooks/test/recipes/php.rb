::Chef::Recipe.include Apache2::Cookbook::Helpers

include_recipe 'php'

apache2_install 'default' do
  mpm 'prefork'
end

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_mod_php ''

file "#{default_docroot_dir}/info.php" do
  content "<?php\nphpinfo();\n?>"
end

apache2_default_site 'php_test'

package 'curl' if platform?('debian')
