unified_mode true

property :startservers, Integer,
         default: 4,
         description: ''

property :serverlimit, Integer,
         default: 16,
         description: ''

property :minsparethreads, Integer,
         default: 64,
         description: ''

property :maxsparethreads, Integer,
         default: 192,
         description: ''

property :threadlimit, Integer,
         default: 192,
         description: ''

property :threadsperchild, Integer,
         default: 64,
         description: ''

property :maxrequestworkers, Integer,
         default: 1024,
         description: ''

property :maxconnectionsperchild, Integer,
         default: 0,
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mpm_event.conf') do
    source 'mods/mpm_event.conf.erb'
    cookbook 'apache2'
    variables(
      startservers: new_resource.startservers,
      serverlimit: new_resource.serverlimit,
      minsparethreads: new_resource.minsparethreads,
      maxsparethreads: new_resource.maxsparethreads,
      threadlimit: new_resource.threadlimit,
      threadsperchild: new_resource.threadsperchild,
      maxrequestworkers: new_resource.maxrequestworkers,
      maxconnectionsperchild: new_resource.maxconnectionsperchild
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
