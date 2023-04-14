apache2_install 'default' do
  mpm 'prefork'
  notifies :restart, 'apache2_service[default]'
end

apache2_mod_php '' do
  notifies :reload, 'apache2_service[default]'
end

file "#{default_docroot_dir}/info.php" do
  content "<?php\nphpinfo();\n?>"
end

apache2_default_site 'php_test' do
  notifies :reload, 'apache2_service[default]'
end

package 'curl' if platform?('debian')

apache2_service 'default' do
  action %i(enable start)
end
