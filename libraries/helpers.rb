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

      def platform_service_name
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
        case node['platform_family']
        when 'rhel', 'amazon', 'fedora'
          File.join(lib_dir_for_machine, 'httpd')
        end
      end

      def libexec_dir
      end

      # Gets the libdir for a given CPU architecture
      def lib_dir_for_machine
        arch = node['kernel']['machine']

        if arch =~ /64/ || %w(armv8l s390x).include?(arch)
          # 64-bit architectures
          # (x86_64 / amd64 / aarch64 / armv8l / etc.)
          '/usr/lib64'
        else
          # 32-bit architectures
          # (i686 / armv7l / s390 / etc.)
          puts arch
          puts "DEBUG #{node}"
          puts "DEBUG #{node['kernel']['machine']}"
          puts "DEBUG #{node['kernel']}"
          '/usr/lib'
        end
      end
    end
  end
end

Chef::Recipe.include(Apache2::Cookbook::Helpers)
Chef::Resource.include(Apache2::Cookbook::Helpers)
