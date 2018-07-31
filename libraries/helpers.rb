module Apache2
  module Cookbook
    module Helpers
      def apache_binary
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon', 'arch', 'suse'
          '/usr/sbin/httpd'
        when 'freebsd'
          '/usr/local/sbin/httpd'
        else
          '/usr/sbin/apache2'
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
    end
  end
end

Chef::Recipe.include(Apache2::Cookbook::Helpers)
Chef::Resource.include(Apache2::Cookbook::Helpers)
