property :location, String,
         default: '/ldap-status'
property :set_handler, String,
         default: 'ldap-status'
property :require, String,
         default: 'local'
action :create do
  template ::File.join(apache_dir, 'mods-available', 'ldap.conf') do
    source 'mods/ldap.conf.erb'
    cookbook 'apache2'
    variables(
      location: new_resource.location,
      set_handler: new_resource.set_handler,
      require: new_resource.require
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
