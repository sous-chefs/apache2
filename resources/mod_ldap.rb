# frozen_string_literal: true

provides :apache2_mod_ldap
unified_mode true

property :location, String,
         default: '/ldap-status',
         description: 'URL path where the module handler is exposed.'

property :set_handler, String,
         default: 'ldap-status',
         description: 'Apache handler used for this location.'

property :require, String,
         default: 'local',
         description: 'Apache Require expression controlling access.'

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

action :delete do
  remove_module_configuration 'ldap'
end

action_class do
  include Apache2::Cookbook::Helpers
end
