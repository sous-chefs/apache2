module Apache2
  module Cookbook
    module Helpers
      def perl_pkg
        if node['platform_family'] == 'freebsd'
          'perl5'
        else
          'perl'
        end
      end
    end
  end
end
