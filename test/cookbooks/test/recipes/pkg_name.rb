# include_recipe 'yum-ius'

# apache2_install 'default_install' do
#   apache_pkg 'httpd24u'
#   notifies :restart, 'apache2_service[default]'
# end

# apache2_site '000-default' do
#   action :disable
#   notifies :reload, 'apache2_service[default]'
# end

# apache2_default_site '' do
#   action :enable
#   notifies :reload, 'apache2_service[default]'
# end

# apache2_module 'ssl' do
#   mod_conf(
#     mod_ssl_pkg: 'httpd24u-mod_ssl'
#   )
#   notifies :reload, 'apache2_service[default]'
# end

# apache2_mod_ssl '' do
#   notifies :reload, 'apache2_service[default]'
# end

# apache2_service 'default' do
#   action %i(enable start)
# end
