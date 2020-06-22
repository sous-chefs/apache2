include Apache2::Cookbook::Helpers
unified_mode true

property :module_name, String,
         default: lazy { "php#{node['php']['version'].to_i}_module" },
         description: 'Module name for the Apache PHP module.'

property :so_filename, String,
         default: lazy { "libphp#{node['php']['version'].to_i}.so" },
         description: 'Filename for the module executable.'

action :create do
  template ::File.join(apache_dir, 'mods-available', "php.conf") do
    source 'mods/php.conf.erb'
    cookbook 'apache2'
    notifies :reload, 'service[apache2]', :delayed
  end

  link ::File.join(apache_dir, 'mods-enabled', "php.conf") do
    to ::File.join(apache_dir, 'mods-available', "php.conf")
    notifies :reload, 'service[apache2]', :delayed
  end

  directory '/var/lib/php/session' do
    owner 'root'
    group 'apache'
    mode '0770'
  end

  apache2_module "php#{node['php']['version'].to_i}" do
    identifier new_resource.module_name
    mod_name new_resource.so_filename
    notifies :reload, 'service[apache2]', :immediately
  end
end
