unified_mode true

property :root_group, String,
         default: lazy { node['root_group'] },
         description: 'Group that the root user on the box runs as. Defaults to platform specific locations, see libraries/helpers.rb'

property :access_file_name, String,
         default: '.htaccess',
         description: 'String: Access filename'

property :log_dir, String,
         default: lazy { default_log_dir },
         description: 'Log directory location. Defaults to platform specific locations, see libraries/helpers.rb'

property :error_log, String,
         default: lazy { default_error_log },
         description: 'Error log location. Defaults to platform specific locations, see libraries/helpers.rb'

property :log_level, String,
         default: 'warn',
         description: 'log level for apache2'

property :apache_user, String,
         default: lazy { default_apache_user },
         description: 'Set to override the default apache2 user. Defaults to platform specific locations, see libraries/helpers.rb'

property :apache_group, String,
         default: lazy { default_apache_group },
         description: 'Set to override the default apache2 user. Defaults to platform specific locations, see libraries/helpers.rb'

property :keep_alive, String,
         equal_to: %w(On Off),
         default: 'On',
         description: 'Persistent connection feature of HTTP/1.1 provide long-lived HTTP sessions'

property :max_keep_alive_requests, Integer,
         default: 100,
         description: 'MaxKeepAliveRequests'

property :keep_alive_timeout, Integer,
         default: 5,
         description: 'KeepAliveTimeout'

property :docroot_dir, String,
         default: lazy { default_docroot_dir },
         description: 'Apache document root.'\
'Defaults to platform specific locations, see libraries/helpers.rb'

property :timeout, [Integer, String],
         coerce: proc { |m| m.is_a?(Integer) ? m.to_s : m },
         default: 300,
         description: 'The number of seconds before receives and sends time out'

property :server_name, String,
         default: 'localhost',
         description: 'Sets the ServerName directive'

property :run_dir, String,
         default: lazy { default_run_dir },
         description: ' Sets the DefaultRuntimeDir directive.'\
'Defaults to platform specific locations, see libraries/helpers.rb'

property :template_cookbook, String,
         default: 'apache2',
         description: 'Cookbook containing the template file'

action :create do
  template 'apache2.conf' do
    if platform_family?('debian')
      path "#{apache_conf_dir}/apache2.conf"
    else
      path "#{apache_conf_dir}/httpd.conf"
    end
    action :create
    source 'apache2.conf.erb'
    cookbook new_resource.template_cookbook
    owner 'root'
    group new_resource.root_group
    mode '0640'
    variables(
      access_file_name: new_resource.access_file_name,
      apache_binary: apache_binary,
      apache_dir: apache_dir,
      apache_user: new_resource.apache_user,
      apache_group: new_resource.apache_group,
      docroot_dir: new_resource.docroot_dir,
      error_log: new_resource.error_log,
      keep_alive: new_resource.keep_alive,
      keep_alive_timeout: new_resource.keep_alive_timeout,
      lock_dir: lock_dir,
      log_dir: new_resource.log_dir,
      log_level: new_resource.log_level,
      max_keep_alive_requests: new_resource.max_keep_alive_requests,
      pid_file: apache_pid_file,
      run_dir: new_resource.run_dir,
      timeout: new_resource.timeout,
      server_name: new_resource.server_name
    )
    notifies :enable, 'service[apache2]', :delayed
    notifies :restart, 'service[apache2]', :delayed
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
