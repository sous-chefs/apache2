#
# Cookbook:: apache2
# Resource:: apache2_site
#
action :enable do
  execute "a2ensite #{new_resource.name}" do
    command "/usr/sbin/a2ensite #{new_resource.name}"
    notifies :reload, 'service[apache2]', :delayed
    not_if { site_enabled?(new_resource.name) }
    only_if { site_available?(new_resource.name) }
  end
end

action :disable do
  execute "a2dissite #{new_resource.name}" do
    command "/usr/sbin/a2dissite #{new_resource.name}"
    notifies :reload, 'service[apache2]', :delayed
    only_if { site_enabled?(new_resource.name) }
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
