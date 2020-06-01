unified_mode true

property :startservers, Integer,
         default: 16,
         description: 'number of server processes to start'

property :minspareservers, Integer,
         default: 16,
         description: 'minimum number of server processes which are kept spare'

property :maxspareservers, Integer,
         default: 32,
         description: 'maximum number of server processes which are kept spare'

property :serverlimit, Integer,
         default: 256,
         description: ''

property :maxrequestworkers, Integer,
         default: 256,
         description: 'maximum number of server processes allowed to start'

property :maxconnectionsperchild, Integer,
         default: 10_000,
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mpm_prefork.conf') do
    source 'mods/mpm_prefork.conf.erb'
    cookbook 'apache2'
    variables(
      startservers: new_resource.startservers,
      minspareservers: new_resource.minspareservers,
      maxspareservers: new_resource.maxspareservers,
      serverlimit: new_resource.serverlimit,
      maxrequestworkers: new_resource.maxrequestworkers,
      maxconnectionsperchild: new_resource.maxconnectionsperchild
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
