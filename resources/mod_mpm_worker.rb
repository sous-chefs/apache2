unified_mode true

property :startservers, Integer,
         default: 4,
         description: 'initial number of server processes to start'

property :minsparethreads, Integer,
         default: 64,
         description: 'minimum number of worker threads which are kept spare'

property :maxsparethreads, Integer,
         default: 192,
         description: 'maximum number of worker threads which are kept spare'

property :threadsperchild, Integer,
         default: 64,
         description: 'constant number of worker threads in each server process'

property :maxrequestworkers, Integer,
         default: 1024,
         description: 'maximum number of threads'

property :maxconnectionsperchild, Integer,
         default: 0,
         description: 'maximum number of requests a server process serves'

property :threadlimit, Integer,
         default: 192,
         description: 'ThreadsPerChild can be changed to this maximum value during a graceful restart. ThreadLimit can only be changed by stopping and starting Apache.'

property :serverlimit, Integer,
         default: 16,
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mpm_worker.conf') do
    source 'mods/mpm_worker.conf.erb'
    cookbook 'apache2'
    variables(
      startservers: new_resource.startservers,
      minsparethreads: new_resource.minsparethreads,
      maxsparethreads: new_resource.maxsparethreads,
      threadsperchild: new_resource.threadsperchild,
      maxrequestworkers: new_resource.maxrequestworkers,
      maxconnectionsperchild: new_resource.maxconnectionsperchild,
      threadlimit: new_resource.threadlimit,
      serverlimit: new_resource.serverlimit
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
