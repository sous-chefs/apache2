# frozen_string_literal: true

provides :apache2_mod_mpm_event
unified_mode true

property :startservers, Integer,
         default: 4,
         description: 'Number of server processes started initially.'

property :serverlimit, Integer,
         default: 16,
         description: 'Upper limit on server processes.'

property :minsparethreads, Integer,
         default: 64,
         description: 'Minimum number of idle worker threads.'

property :maxsparethreads, Integer,
         default: 192,
         description: 'Maximum number of idle worker threads.'

property :threadlimit, Integer,
         default: 192,
         description: 'Upper limit on threads per child process.'

property :threadsperchild, Integer,
         default: 64,
         description: 'Number of threads in each child process.'

property :maxrequestworkers, Integer,
         default: 1024,
         description: 'Maximum number of simultaneous requests.'

property :maxconnectionsperchild, Integer,
         default: 0,
         description: 'Connections served before recycling a child; zero means unlimited.'

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

action :delete do
  remove_module_configuration 'mpm_event'
end

action_class do
  include Apache2::Cookbook::Helpers
end
