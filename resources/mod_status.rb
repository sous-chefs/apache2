unified_mode true

property :location, String,
         default: '/server-status',
         description: ''

property :status_allow_list, [String, Array],
         default: %w(127.0.0.1 ::1),
         description: 'Clients in the specified IP address ranges can access the resource.
For full description see https://httpd.apache.org/docs/2.4/mod/mod_authz_core.html#require'

property :extended_status, String,
         equal_to: %w(On Off),
         default: 'Off',
         description: 'For info see: https://httpd.apache.org/docs/current/mod/mod_status.html'

property :proxy_status, String,
         equal_to: %w(On Off),
         default: 'On',
         description: 'For info see: https://httpd.apache.org/docs/current/mod/mod_status.html'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'status.conf') do
    source 'mods/status.conf.erb'
    cookbook 'apache2'
    variables(
      location: new_resource.location,
      status_allow_list: Array(new_resource.status_allow_list),
      extended_status: new_resource.extended_status,
      proxy_status: new_resource.proxy_status
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
