unified_mode true

property :status_location, String,
         default: '/balancer-manager',
         description: ''

property :set_handler, String,
         default: 'balancer-manager',
         description: ''

property :require, String,
         default: 'local',
         description: 'For full description see https://httpd.apache.org/docs/2.4/mod/mod_authz_core.html#require'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'proxy_balancer.conf') do
    source 'mods/proxy_balancer.conf.erb'
    cookbook 'apache2'
    variables(
      status_location: new_resource.status_location,
      set_handler: new_resource.set_handler,
      require: new_resource.require
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
