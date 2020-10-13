property :name, String, default: ''

property :module_name, String,
         default: 'wsgi_module',
         description: 'Module name for the Apache WSGI module.'

property :so_filename, String,
         default: lazy { apache_mod_wsgi_filename },
         description: 'Filename for the module executable.'

property :package_name, [String, Array],
         default: lazy { apache_mod_wsgi_package },
         description: 'Package that contains the Apache WSGI module itself'

property :install_package, [true, false],
         default: true,
         description: 'Whether to install the Apache WSGI module package'

action :create do
  # install mod_wsgi package (if requested)
  package new_resource.package_name do
    only_if { new_resource.install_package }
    notifies :delete, 'directory[purge distro conf.modules.d]', :immediately
  end

  directory 'purge distro conf.modules.d' do
    path "#{apache_dir}/conf.modules.d"
    recursive true
    action :nothing
  end

  apache2_module 'wsgi' do
    identifier new_resource.module_name
    mod_name new_resource.so_filename
    notifies :restart, 'service[apache2]'
  end
end
