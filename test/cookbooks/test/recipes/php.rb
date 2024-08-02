apache2_install 'default' do
  mpm 'prefork'
  notifies :restart, 'apache2_service[default]'
end

if apache_mod_php_supported?
  apache2_mod_php '' do
    notifies :reload, 'apache2_service[default]'
  end
else
  apache2_module 'proxy' do
    notifies :reload, 'apache2_service[default]'
  end
  apache2_module 'proxy_fcgi' do
    notifies :reload, 'apache2_service[default]'
  end
  apache2_mod_proxy 'proxy' do
    notifies :reload, 'apache2_service[default]'
  end
  php_fpm_pool 'nagios' do
    user default_apache_user
    group default_apache_group
    listen_user default_apache_user
    listen_group default_apache_group
    notifies :install, 'apache2_install[default]'
  end
  apache2_conf 'custom_php_pool' do
    template_cookbook 'test'
    options(
      apache_php_handler: "proxy:unix:#{php_fpm_socket}|fcgi://localhost"
    )
    notifies :reload, 'apache2_service[default]'
  end
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
