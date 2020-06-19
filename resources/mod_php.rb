include Apache2::Cookbook::Helpers
unified_mode true

property :module_name, String,
         default: lazy { "php#{apache_default_php_version}" },
         description: 'Module name for the Apache PHP module.'

property :so_filename, String,
         default: lazy { "libphp#{apache_default_php_version}.so" },
         description: 'Filename for the module executable.'

action :create do
  case node['platform_family']
  when 'debian'
    if platform?('ubuntu') && node['platform_version'].to_f < 16.04
      package 'libapache2-mod-php5'
    elsif platform?('debian') && node['platform_version'].to_f < 9
      package 'libapache2-mod-php5'
    else
      package 'libapache2-mod-php'
    end
  when 'arch'
    package 'php-apache' do
      notifies :run, 'execute[generate-module-list]', :immediately
    end
  when 'rhel', 'amazon', 'fedora', 'suse'
    package 'which'
    package 'php' do
      notifies :run, 'execute[generate-module-list]', :immediately
      not_if 'which php'
    end
  when 'freebsd'
    package %w(php56 libxml2)

    %w(mod_php56).each do |pkg|
      package pkg do
        options '-I'
      end
    end
  end

  template ::File.join(apache_dir, 'mods-available', 'php.conf') do
    source 'mods/php.conf.erb'
    cookbook 'apache2'
  end
end
