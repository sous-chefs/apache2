include Apache2::Cookbook::Helpers

property :root_group, String,
         default: lazy { default_apache_root_group },
         description: 'Group that the root user on the box runs as'
property :apache_user, String,
         default: lazy { default_apache_user },
         description: 'Set to override the default apache2 user'
property :apache_group, String,
         default: lazy { default_apache_group },
         description: 'Set to override the default apache2 user'
property :log_dir, String,
         default: lazy { default_log_dir },
         description: 'Log directory'
property :error_log, String,
         default: lazy { default_error_log },
         description: 'Log directory'
property :log_level, String,
         default: 'warn',
         description: 'log level for apache2'
property :apache_locale, String,
         default: 'system',
         description: 'Locale for apache2, defaults to the system locale'
property :status_url, String,
         default: 'http://localhost:80/server-status',
         description: 'URL for status checks'
property :httpd_t_timeout, Integer,
         default: 10,
         description: 'Service timeout setting. Defaults to 10 seconds'
property :mpm, String,
         default: lazy { default_mpm },
         description: 'Multi-processing Module, defaults to each platforms default'
property :listen, [String, Array],
         default: %w(80 443),
         description: 'Port to listen on. Defaults to both 80 & 443'

action :install do
  package [apache_pkg, perl_pkg]
  package 'perl-Getopt-Long-Descriptive' if platform?('fedora')

  directory apache_dir do
    mode '0751'
    owner 'root'
    group new_resource.root_group
  end

  %w(sites-available sites-enabled mods-available mods-enabled conf-available conf-enabled).each do |dir|
    directory "#{apache_dir}/#{dir}" do
      mode '0750'
      owner 'root'
      group new_resource.root_group
    end
  end

  directory new_resource.log_dir do
    mode '0750'
    recursive true
  end

  %w(a2ensite a2dissite a2enmod a2dismod a2enconf a2disconf).each do |modscript|
    link "/usr/sbin/#{modscript}" do
      action :delete
      only_if { ::File.symlink?("/usr/sbin/#{modscript}") }
    end

    template "/usr/sbin/#{modscript}" do
      source "#{modscript}.erb"
      cookbook 'apache2'
      mode '0700'
      owner 'root'
      variables(
        apachectl: apachectl,
        apache_dir: apache_dir
      )
      group new_resource.root_group
      action :create
    end
  end

  unless platform_family?('debian')
    cookbook_file '/usr/local/bin/apache2_module_conf_generate.pl' do
      source 'apache2_module_conf_generate.pl'
      cookbook 'apache2'
      mode '0750'
      owner 'root'
      group new_resource.root_group
    end

    execute 'generate-module-list' do
      command "/usr/local/bin/apache2_module_conf_generate.pl #{lib_dir} #{apache_dir}/mods-available"
      action :nothing
    end
  end

  if platform_family?('freebsd')
    directory "#{apache_dir}/Includes" do
      action :delete
      recursive true
    end

    directory "#{apache_dir}/extra" do
      action :delete
      recursive true
    end
  end

  if platform_family?('suse')
    directory "#{apache_dir}/vhosts.d" do
      action :delete
      recursive true
    end

    %w(charset.conv default-vhost.conf default-server.conf default-vhost-ssl.conf errors.conf listen.conf mime.types mod_autoindex-defaults.conf mod_info.conf mod_log_config.conf mod_status.conf mod_userdir.conf mod_usertrack.conf uid.conf).each do |file|
      file "#{apache_dir}/#{file}" do
        action :delete
        backup false
      end
    end
  end

  directory "#{apache_dir}/ssl" do
    mode '0750'
    owner 'root'
    group new_resource.root_group
  end

  directory cache_dir do
    mode '0750'
    owner 'root'
    group new_resource.root_group
  end

  directory lock_dir do
    mode '0750'
    if node['platform_family'] == 'debian'
      owner new_resource.apache_user
    else
      owner 'root'
    end
    group new_resource.root_group
  end

  template "/etc/sysconfig/#{apache_platform_service_name}" do
    source 'etc-sysconfig-httpd.erb'
    cookbook 'apache2'
    owner 'root'
    group new_resource.root_group
    mode '0644'
    variables(
      apache_binary: apache_binary,
      apache_dir: apache_dir
    )
    only_if { platform_family?('rhel', 'amazon', 'fedora', 'suse') }
  end

  template "#{apache_dir}/envvars" do
    source 'envvars.erb'
    cookbook 'apache2'
    owner 'root'
    group new_resource.root_group
    mode '0644'
    variables(
      lock_dir: lock_dir,
      log_dir: new_resource.log_dir,
      apache_user: new_resource.apache_user,
      apache_group: new_resource.apache_group,
      pid_file: apache_pid_file,
      apache_locale: new_resource.apache_locale,
      status_url: new_resource.status_url
    )
    only_if { platform_family?('debian') }
  end

  template 'apache2.conf' do
    if platform_family?('debian')
      path "#{apache_conf_dir}/apache2.conf"
    else
      path "#{apache_conf_dir}/httpd.conf"
    end
    action :create
    source 'apache2.conf.erb'
    cookbook 'apache2'
    owner 'root'
    group new_resource.root_group
    mode '0640'
    variables(
      apache_binary: apache_binary,
      apache_dir: apache_dir,
      lock_dir: lock_dir,
      log_dir: new_resource.log_dir,
      error_log: new_resource.error_log,
      log_level: new_resource.log_level,
      pid_file: apache_pid_file,
      apache_user: new_resource.apache_user,
      apache_group: new_resource.apache_group
    )
  end

  apache2_conf 'security'
  apache2_conf 'charset'

  template 'ports.conf' do
    path "#{apache_dir}/ports.conf"
    source 'ports.conf.erb'
    cookbook 'apache2'
    mode '0644'
    variables(listen: new_resource.listen)
  end

  # MPM Support Setup
  case new_resource.mpm
  when 'event'
    if platform_family?('suse')
      package %w(apache2-prefork apache2-worker) do
        action :remove
      end

      package 'apache2-event'
    else
      %w(mpm_prefork mpm_worker).each do |mpm|
        apache2_module mpm do
          action :disable
        end
      end

      apache2_module 'mpm_event' do
        conf true
        apache_service_notification :restart
      end
    end

  when 'prefork'
    if platform_family?('suse')
      package %w(apache2-event apache2-worker) do
        action :remove
      end

      package 'apache2-prefork'
    else
      %w(mpm_event mpm_worker).each do |mpm|
        apache2_module mpm do
          action :disable
        end
      end

      apache2_module 'mpm_prefork' do
        conf true
        apache_service_notification :restart
      end
    end

  when 'worker'
    if platform_family?('suse')
      package %w(apache2-event apache2-prefork) do
        action :remove
      end

      package 'apache2-worker'
    else
      %w(mpm_prefork mpm_event).each do |mpm|
        apache2_module mpm do
          action :disable
        end
      end

      apache2_module 'mpm_worker' do
        conf true
        apache_service_notification :restart
      end
    end
  end

  default_modules.each do |mod|
    recipe = mod =~ /^mod_/ ? mod : "mod_#{mod}"
    include_recipe "apache2::#{recipe}"
  end

  service 'apache2' do
    service_name apache_platform_service_name
    supports [:start, :restart, :reload, :status]
    action [:enable, :start]
    only_if "#{apache_binary} -t", environment: { 'APACHE_LOG_DIR' => new_resource.log_dir }, timeout: new_resource.httpd_t_timeout
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
