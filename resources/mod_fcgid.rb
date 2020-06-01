unified_mode true

property :add_handler, Hash,
         default: { 1 => 'fcgid-script .fcgi' },
         description: 'A key ordered hash of handlers'

property :ipc_connect_timeout, Integer,
         default: 20,
         description: 'IPC Connection Timeout in seconds'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'fcgid.conf') do
    source 'mods/fcgid.conf.erb'
    cookbook 'apache2'
    variables(
      add_handler: new_resource.add_handler,
      ipc_connect_timeout: new_resource.ipc_connect_timeout
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
