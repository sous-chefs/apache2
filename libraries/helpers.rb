# frozen_string_literal: true

module Apache2
  module Cookbook
    module Helpers
      def apache_binary
        if platform_family?('debian')
          '/usr/sbin/apache2'
        else
          '/usr/sbin/httpd'
        end
      end

      def apache_platform_service_name
        if platform_family?('debian', 'suse')
          'apache2'
        else
          'httpd'
        end
      end

      def default_types_config
        '/etc/mime.types'
      end

      def apachectl
        if platform_family?('debian', 'suse')
          '/usr/sbin/apache2ctl'
        else
          '/usr/sbin/apachectl'
        end
      end

      def apache_dir
        if platform_family?('debian', 'suse')
          '/etc/apache2'
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
        else
          '/usr/lib/apache2'
        end
      end

      def apache_libexec_dir
        if platform_family?('suse')
          lib_dir
        else
          File.join(lib_dir, 'modules')
        end
      end

      def apache_conf_dir
        if platform_family?('debian', 'suse')
          '/etc/apache2'
        else
          '/etc/httpd/conf'
        end
      end

      def icon_dir
        if platform_family?('debian', 'suse')
          '/usr/share/apache2/icons'
        else
          '/usr/share/httpd/icons'
        end
      end

      def perl_pkg
        'perl'
      end

      def default_apache_pkg
        if platform_family?('debian', 'suse')
          'apache2'
        else
          'httpd'
        end
      end

      def default_log_dir
        if platform_family?('debian', 'suse')
          '/var/log/apache2'
        else
          '/var/log/httpd'
        end
      end

      def cache_dir
        if platform_family?('debian', 'suse')
          '/var/cache/apache2'
        else
          '/var/cache/httpd'
        end
      end

      def default_cache_root
        if platform_family?('debian', 'suse')
          ::File.join(cache_dir, 'proxy')
        else
          ::File.join(cache_dir, 'mod_cache_disk')
        end
      end

      def lock_dir
        if platform_family?('debian')
          '/var/lock/apache2'
        else
          '/var/run/httpd'
        end
      end

      def default_docroot_dir
        if platform_family?('suse')
          '/srv/www/htdocs'
        else
          '/var/www/html'
        end
      end

      def default_cgibin_dir
        if platform_family?('debian')
          '/usr/www/cgi-bin'
        else
          '/var/www/cgi-bin'
        end
      end

      def default_run_dir
        if platform_family?('debian')
          '/var/run/apache2'
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
        else
          'apache'
        end
      end

      def default_apache_group
        case node['platform_family']
        when 'suse'
          'www'
        when 'debian'
          'www-data'
        else
          'apache'
        end
      end

      def default_modules
        default_modules = %w(status alias auth_basic authn_core authn_file authz_core authz_groupfile
                             authz_host authz_user autoindex deflate dir env mime negotiation setenvif)

        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          default_modules.push('log_config', 'logio', 'unixd', 'systemd')
        when 'suse'
          default_modules.push('log_config', 'logio')
        else
          default_modules
        end
      end

      def default_mpm
        'event'
      end

      def default_error_log
        'error.log'
      end

      def default_access_log
        'access.log'
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

      def apache_site_enabled?(site_name)
        ::File.symlink?("#{apache_dir}/sites-enabled/#{site_name}.conf")
      end

      def apache_site_available?(site_name)
        ::File.exist?("#{apache_dir}/sites-available/#{site_name}.conf")
      end

      def apache_devel_package(mpm)
        case node['platform_family']
        when 'debian'
          if mpm == 'prefork'
            'apache2-prefork-dev'
          else
            'apache2-dev'
          end
        when 'suse'
          'apache2-devel'
        else
          'httpd-devel'
        end
      end

      def default_pass_phrase_dialog
        platform?('ubuntu') ? 'exec:/usr/share/apache2/ask-for-passphrase' : 'builtin'
      end

      def default_session_cache
        if platform_family?('rhel', 'fedora', 'suse', 'amazon')
          'shmcb:/var/cache/mod_ssl/scache(512000)'
        else
          'shmcb:/var/run/apache2/ssl_scache'
        end
      end

      def config_file?(mod_name)
        %w(ldap
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
      end

      def pagespeed_url
        suffix = platform_family?('rhel', 'fedora', 'amazon') ? 'rpm' : 'deb'

        if node['kernel']['machine'] =~ /^i[36']86$/
          "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_i386.#{suffix}"
        else
          "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.#{suffix}"
        end
      end

      def default_site_template_source
        platform_family?('debian') ? "#{default_site_name}.conf.erb" : 'welcome.conf.erb'
      end

      # mod_php
      def apache_mod_php_supported?
        case node['platform_family']
        when 'amazon', 'fedora'
          false
        when 'rhel'
          node['platform_version'].to_i < 9
        else
          true
        end
      end

      def apache_mod_php_package
        case node['platform_family']
        when 'debian'
          'libapache2-mod-php'
        when 'rhel'
          'mod_php'
        when 'suse'
          if platform?('opensuse') && node['platform_version'].to_f >= 15.5
            'apache2-mod_php8'
          else
            'apache2-mod_php7'
          end
        end
      end

      def apache_mod_php_modulename
        case node['platform_family']
        when 'amazon'
          'php8_module'
        when 'rhel'
          'php7_module'
        when 'debian'
          if platform?('debian') && node['platform_version'].to_i >= 12
            'php_module'
          elsif platform?('ubuntu') && node['platform_version'].to_f >= 22.04
            'php_module'
          else
            'php7_module'
          end
        else
          'php7_module'
        end
      end

      def apache_mod_php_filename
        case node['platform_family']
        when 'debian'
          if platform?('debian') && node['platform_version'].to_i == 11
            'libphp7.4.so'
          elsif platform?('debian') && node['platform_version'].to_i == 12
            'libphp8.2.so'
          elsif platform?('debian') && node['platform_version'].to_i >= 13
            'libphp8.4.so'
          elsif platform?('ubuntu') && node['platform_version'].to_f >= 24.04
            'libphp8.3.so'
          elsif platform?('ubuntu') && node['platform_version'].to_f >= 22.04
            'libphp8.1.so'
          else
            'libphp7.0.so'
          end
        when 'rhel'
          'libphp7.so'
        when 'suse'
          if platform?('opensuse') && node['platform_version'].to_f >= 15.5
            'mod_php8.so'
          else
            'mod_php7.so'
          end
        end
      end

      # mod_wsgi
      def apache_mod_wsgi_package
        case node['platform_family']
        when 'debian'
          'libapache2-mod-wsgi-py3'
        when 'rhel', 'fedora', 'amazon'
          'python3-mod_wsgi'
        when 'suse'
          'apache2-mod_wsgi-python3'
        end
      end

      def apache_mod_wsgi_filename
        if platform_family?('rhel', 'fedora', 'amazon')
          'mod_wsgi_python3.so'
        else
          'mod_wsgi.so'
        end
      end

      def apache_mod_auth_cas_install_method
        if platform_family?('rhel', 'suse', 'fedora', 'amazon')
          'source'
        else
          'package'
        end
      end

      def apache_mod_auth_cas_devel_packages
        if platform_family?('rhel', 'amazon', 'fedora')
          %w(openssl-devel libcurl-devel pcre-devel libtool)
        elsif platform_family?('debian')
          %w(libssl-dev libcurl4-openssl-dev libpcre++-dev libtool)
        elsif platform_family?('suse')
          %w(libopenssl-devel libcurl-devel pcre-devel libtool)
        end
      end
    end
  end
end
