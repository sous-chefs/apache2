module Helpers
  module Apache
    include MiniTest::Chef::Resources
    include MiniTest::Chef::RunState

    def apache_config_parses?
      %x{#{node['apache']['binary']} -t}
      $?.success?
    end
    def apache_enabled_modules
      Dir["#{node['apache']['dir']}/mods-enabled/*.load"].map{|s| File.basename(s, '.load')}.sort
    end
    def apache_service
      service(case node['platform']
        when "debian","ubuntu" then "apache2"
        when "freebsd" then "apache22"
        else "httpd"
      end)
    end
    def config
      file(case node['platform']
        when "debian","ubuntu" then "#{node['apache']['dir']}/apache2.conf"
        when "freebsd" then "#{node['apache']['dir']}/httpd.conf"
        else "#{node['apache']['dir']}/conf/httpd.conf"
      end)
    end
  end
end
