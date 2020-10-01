unified_mode true

property :site_name, String,
         name_property: true,
         description: 'Name of the site to enable/disable'

action :enable do
  execute "a2ensite #{new_resource.site_name}" do
    command "/usr/sbin/a2ensite #{new_resource.site_name}"
    notifies :reload, 'service[apache2]', :delayed
    not_if { apache_site_enabled?(new_resource.site_name) }
    only_if { apache_site_available?(new_resource.site_name) }
  end
end

action :disable do
  execute "a2dissite #{new_resource.site_name}" do
    command "/usr/sbin/a2dissite #{new_resource.site_name}"
    notifies :reload, 'service[apache2]', :delayed
    only_if { apache_site_enabled?(new_resource.site_name) }
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
