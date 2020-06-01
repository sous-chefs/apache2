unified_mode true

property :request_read_timeout, Hash,
         default: {
           '1': 'header=20-40,minrate=500',
           '2': 'body=10,minrate=500',
         },
         description: 'A hash of ordered rules.
For full information see https://httpd.apache.org/docs/2.4/mod/mod_reqtimeout.html'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'reqtimeout.conf') do
    source 'mods/reqtimeout.conf.erb'
    cookbook 'apache2'
    variables(request_read_timeout: new_resource.request_read_timeout)
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
