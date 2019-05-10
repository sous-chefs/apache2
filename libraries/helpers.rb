module Apache2
  module Cookbook
    module Helpers
      def apache_binary
        case node['platform_family']
        when 'debian'
          '/usr/sbin/apache2'
        when 'freebsd'
          '/usr/local/sbin/httpd'
        else
          '/usr/sbin/httpd'
        end
      end

      def apache_platform_service_name
        case node['platform_family']
        when 'debian', 'suse'
          'apache2'
        when 'freebsd'
          'apache24'
        else
          'httpd'
        end
      end

      def default_types_config
        case node['platform_family']
        when 'arch'
          "#{apache_dir}/conf/mime.types"
        when 'freebsd'
          "#{apache_dir}/mime.types"
        else
          '/etc/mime.types'
        end
      end

      def apachectl
        case node['platform_family']
        when 'debian', 'suse'
          '/usr/sbin/apache2ctl'
        when 'freebsd'
          '/usr/local/sbin/apachectl'
        else
          '/usr/sbin/apachectl'
        end
      end

      def apache_dir
        case node['platform_family']
        when 'debian', 'suse'
          '/etc/apache2'
        when 'freebsd'
          '/usr/local/etc/apache24'
        else
          '/etc/httpd'
        end
      end

      def lib_dir
        arch = node['kernel']['machine']

        case node['platform_family']
        when 'rhel', 'amazon', 'fedora'
          if arch =~ /64/ || %w(armv8l s390x).include?(arch)
            '/usr/lib64/httpd'
          else
            '/usr/lib/httpd'
          end
        when 'suse'
          if arch =~ /64/ || %w(armv8l s390x).include?(arch)
            '/usr/lib64/apache2'
          else
            '/usr/lib/apache2'
          end
        when 'freebsd'
          '/usr/local/libexec/apache24'
        when 'arch'
          '/usr/lib/httpd'
        else
          '/usr/lib/apache2'
        end
      end

      def libexec_dir
        case node['platform_family']
        when 'freebsd', 'suse'
          lib_dir
        else
          File.join(lib_dir, 'modules')
        end
      end

      def apache_conf_dir
        case node['platform_family']
        when 'debian', 'suse'
          '/etc/apache2'
        when 'freebsd'
          '/usr/local/etc/apache24'
        else
          '/etc/httpd/conf'
        end
      end

      def icon_dir
        case node['platform_family']
        when 'debian', 'suse'
          '/usr/share/apache2/icons'
        when 'freebsd'
          '/usr/local/www/apache24/icons'
        else
          '/usr/share/httpd/icons'
        end
      end

      def perl_pkg
        if node['platform_family'] == 'freebsd'
          'perl5'
        else
          'perl'
        end
      end

      def apache_pkg
        case node['platform_family']
        when 'amazon'
          if node['platform_version'] == '2'
            'httpd'
          else
            'httpd24'
          end
        when 'rhel'
          if node['platform_version'] < '7'
            'httpd24'
          else
            'httpd'
          end
        when 'debian', 'suse'
          'apache2'
        when 'arch'
          'apache'
        when 'freebsd'
          'apache24'
        else
          'httpd'
        end
      end

      def default_log_dir
        case node['platform_family']
        when 'debian', 'suse'
          '/var/log/apache2'
        when 'freebsd'
          '/var/log'
        else
          '/var/log/httpd'
        end
      end

      def cache_dir
        case node['platform_family']
        when 'debian', 'suse'
          '/var/cache/apache2'
        when 'freebsd'
          '/var/cache/apache24'
        else
          '/var/cache/httpd'
        end
      end

      def default_cache_root
        case node['platform_family']
        when 'debian', 'suse', 'freebsd'
          ::File.join(cache_dir, 'proxy')
        else
          ::File.join(cache_dir, 'mod_cache_disk')
        end
      end

      def lock_dir
        case node['platform_family']
        when 'debian'
          '/var/lock/apache2'
        when 'freebsd'
          '/var/run'
        else
          '/var/run/httpd'
        end
      end

      def default_docroot_dir
        case node['platform_family']
        when 'arch'
          '/srv/http'
        when 'freebsd'
          '/usr/local/www/apache24/data'
        when 'suse'
          '/srv/www/htdocs'
        else
          '/var/www/html'
        end
      end

      def default_cgibin_dir
        case node['platform_family']
        when 'debian'
          '/usr/www/cgi-bin'
        when 'arch'
          '/usr/share/httpd/cgi-bin'
        when 'freebsd'
          '/usr/lib/cgi-bin'
        else
          '/var/www/cgi-bin'
        end
      end

      def default_run_dir
        case node['platform_family']
        when 'debian'
          '/var/run/apache2'
        when 'freebsd'
          '/var/run'
        else
          '/var/run/httpd'
        end
      end

      def default_apache_user
        case node['platform_family']
        when 'suse'
          'wwwrun'
        when 'debian'
          'www-data'
        when 'arch'
          'http'
        when 'freebsd'
          'www'
        else
          'apache'
        end
      end

      def default_apache_group
        case node['platform_family']
        when 'suse', 'freebsd'
          'www'
        when 'debian'
          'www-data'
        when 'arch'
          'http'
        else
          'apache'
        end
      end

      def default_apache_root_group
        node['root_group']
      end

      def default_modules
        default_modules = %w(status alias auth_basic authn_core authn_file authz_core authz_groupfile
                             authz_host authz_user autoindex deflate dir env mime negotiation setenvif)

        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          default_modules.concat %w(log_config logio unixd)
          default_modules.concat %w(systemd) if node['init_package'] == 'systemd'
          default_modules
        when 'arch', 'freebsd'
          default_modules << %w(log_config logio unixd)
        when 'suse'
          default_modules << %w(log_config logio)
        else
          default_modules
        end
      end

      def default_mpm
        case node['platform']
        when 'debian'
          'worker'
        when 'linuxmint', 'ubuntu'
          'event'
        else
          'prefork'
        end
      end

      def default_error_log
        if platform_family?('freebsd')
          'httpd-error.log'
        else
          'error.log'
        end
      end

      def default_access_log
        if platform_family?('freebsd')
          'httpd-access.log'
        else
          'access.log'
        end
      end

      def default_mime_magic_file
        ::File.join(apache_dir, 'magic')
      end

      def apache_pid_file
        case node['platform_family']
        when 'suse'
          '/var/run/httpd2.pid'
        when 'debian'
          '/var/run/apache2/apache2.pid'
        when 'freebsd'
          '/var/run/httpd.pid'
        else
          '/var/run/httpd/httpd.pid'
        end
      end

      def conf_enabled?(new_resource)
        ::File.symlink?("#{apache_dir}/conf-enabled/#{new_resource.name}.conf")
      end

      def mod_enabled?(new_resource)
        ::File.symlink?("#{apache_dir}/mods-enabled/#{new_resource.name}.load")
      end

      def site_enabled?(site_name)
        ::File.symlink?("#{apache_dir}/sites-enabled/#{site_name}.conf")
      end

      def site_available?(site_name)
        ::File.exist?("#{apache_dir}/sites-available/#{site_name}.conf")
      end

      def apache_devel_package(mpm)
        case node['platform_family']
        when 'amazon'
          if node['platform_version'].to_i == 2
            'httpd-devel'
          else
            'httpd24-devel'
          end
        when 'debian'
          if mpm == 'prefork'
            'apache2-prefork-dev'
          else
            'apache2-dev'
          end
        else
          'httpd-devel'
        end
      end

      def default_pass_phrase_dialog
        node['platform'] == 'ubuntu' ? 'exec:/usr/share/apache2/ask-for-passphrase' : 'builtin'
      end

      def default_session_cache
        case node['platform_family']
        when 'freebsd'
          'shmcb:/var/run/ssl_scache(512000)'
        when 'rhel', 'fedora', 'suse', 'amazon'
          'shmcb:/var/cache/mod_ssl/scache(512000)'
        else
          'shmcb:/var/run/apache2/ssl_scache'
        end
      end

      def config_file?(mod_name)
        if %w(ldap
              actions
              alias
              auth_cas
              autoindex
              cache_disk
              cgid
              dav_fs
              deflate
              dir
              fastcgi
              fcgid
              include
              info
              ldap
              mime_magic
              mime
              negotiation
              pagespeed
              proxy_balancer
              proxy_ftp
              proxy
              reqtimeout
              setenvif
              ssl
              status
              userdir
              mpm_event
              mpm_prefork
              mpm_worker
        ).include?(mod_name)
          true
        else
          false
        end
      end

      def pagespeed_url
        suffix = ''
        case node['platform_family']
        when 'rhel'
          suffix = 'rpm'
        when 'debian'
          suffix = 'deb'
        end

        if node['kernel']['machine'] =~ /^i[36']86$/
          "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_i386.#{suffix}"
        else
          "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.#{suffix}"
        end
      end

      def default_site_template_source
        node['platform_family'] == 'debian' ? "#{default_site_name}.conf.erb" : 'welcome.conf.erb'
      end
    end
  end
end
