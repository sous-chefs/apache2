module Apache2
  module Cookbook
    module Helpers
      def apache_binary
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon', 'arch'
          '/usr/sbin/httpd'
        when 'suse'
          '/usr/sbin/httpd'
        when 'debian'
          '/usr/sbin/apache2'
        when 'freebsd'
          '/usr/local/sbin/httpd'
        else
          '/usr/sbin/apache2'
        end
      end
    end
  end
end
