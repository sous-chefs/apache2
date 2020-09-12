property :name, String, default: ''

property :module_name, String,
         default: lazy { apache_mod_php_modulename },
         description: 'Module name for the Apache PHP module.'

property :so_filename, String,
         default: lazy { apache_mod_php_filename },
         description: 'Filename for the module executable.'

property :package_name, [String, Array],
         default: lazy { apache_mod_php_package },
         description: 'Package that contains the Apache PHP module itself'

property :install_package, [true, false],
         default: true,
         description: 'Whether to install the Apache PHP module package'

action :create do
  # install mod_php package (if requested)
  package new_resource.package_name do
    only_if { new_resource.install_package }
    notifies :delete, 'directory[purge distro conf.modules.d]', :immediately
    notifies :delete, 'directory[purge distro conf.d]', :immediately
  end

  directory 'purge distro conf.modules.d' do
    path "#{apache_dir}/conf.modules.d"
    recursive true
    action :nothing
  end

  directory 'purge distro conf.d' do
    path "#{apache_dir}/conf.d"
    recursive true
    action :nothing
  end

  apache2_module 'php' do
    identifier new_resource.module_name
    mod_name new_resource.so_filename
    conf true
    template_cookbook 'apache2'
    notifies :restart, 'service[apache2]'
  end
end
