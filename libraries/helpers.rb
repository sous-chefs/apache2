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
    end
  end
end

Chef::Recipe.include(Apache2::Cookbook::Helpers)
Chef::Resource.include(Apache2::Cookbook::Helpers)
