include Apache2::Cookbook::Helpers
unified_mode true

property :module_name, String,
         default: lazy { apache_mod_php_modulename },
         description: 'Module name for the Apache PHP module.'

property :so_filename, String,
         default: lazy { apache_mod_php_filename },
         description: 'Filename for the module executable.'

property :package_name, String,
         default: lazy { apache_mod_php_package },
         description: 'Package that contains the Apache PHP module itself'

property :install_package, [true, false],
         default: true,
         description: 'Whether to install the Apache PHP module package'

action :create do
  # install mod_php package
  package new_resource.package_name if new_resource.install_package

  # manually manage conf file since filename is different than module
  template ::File.join(apache_dir, 'mods-available', 'php.conf') do
    source 'mods/php.conf.erb'
    cookbook 'apache2'
    notifies :reload, 'service[apache2]', :delayed
  end

  directory '/var/lib/php/session' do
    owner 'root'
    group default_apache_group
    mode '770'
  end

  apache2_module 'php' do
    identifier new_resource.module_name
    mod_name new_resource.so_filename
    notifies :reload, 'service[apache2]', :immediately
  end
end
