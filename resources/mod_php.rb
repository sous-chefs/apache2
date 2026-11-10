# frozen_string_literal: true

provides :apache2_mod_php
unified_mode true
include Apache2::Cookbook::Helpers

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
  raise "apache2_mod_php resource is not supported on #{node['platform']} #{node['platform_version']}" unless apache_mod_php_supported?

  if platform_family?('suse')
    # The package's postinstall script calls a2enmod php8. Prepare the entry
    # before installing because apache2_install replaces the distro helper.
    template ::File.join(apache_dir, 'mods-available', "#{php_module_resource_name}.conf") do
      source 'mods/php.conf.erb'
      cookbook 'apache2'
    end

    apache2_module php_module_resource_name do
      identifier new_resource.module_name
      mod_name new_resource.so_filename
      conf false
    end
  end

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
    not_if { platform_family?('suse') }
  end
end

action :delete do
  # Keep the module entry available to the package's uninstall hooks.
  package new_resource.package_name do
    action :remove
    only_if { new_resource.install_package && !new_resource.package_name.nil? }
  end

  apache2_module php_module_resource_name do
    conf false
    action :delete
  end
end

action_class do
  include Apache2::Cookbook::Helpers

  def php_module_resource_name
    platform_family?('suse') ? apache_mod_php_package.delete_prefix('apache2-mod_') : 'php'
  end
end
