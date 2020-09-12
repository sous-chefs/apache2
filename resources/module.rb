unified_mode true

property :mod_name, String,
         default: lazy { "mod_#{name}.so" },
         description: 'The full name of the file'

property :path, String,
         default: lazy { "#{apache_libexec_dir}/#{mod_name}" },
         description: ''

property :identifier, String,
         default: lazy { "#{name}_module" },
         description: 'String to identify the module for the `LoadModule` directive'

property :mod_conf, Hash,
        default: {},
        description: 'Pass properties to apache2_mod_<name> and config file template'

property :conf, [true, false],
         default: lazy { config_file?(name) },
         description: 'The default is set by the config_file? helper. Override to set whether the module should have a config file'

property :template_cookbook, String,
         default: '',
         description: 'Cookbook to source the config file template from'

property :apache_service_notification, Symbol,
         equal_to: %i( reload restart ),
         default: :reload,
         description: 'Service notifcation for apache2 service, accepts reload or restart.'

action :enable do
  # Create apache2_mod_resource if we want it configured
  if new_resource.conf
    # manage template directly if using template from external cookbook since no mod_ resource for it, probably
    if !new_resource.template_cookbook.empty?
      template ::File.join(apache_dir, 'mods-available', "#{new_resource.name}.conf") do
        source "mods/#{new_resource.name}.conf.erb"
        cookbook new_resource.template_cookbook
        variables new_resource.mod_conf
      end
    else
      declare_resource("apache2_mod_#{new_resource.name}".to_sym, 'default') do
        new_resource.mod_conf.each { |k, v| send(k, v) }
      end
    end
  end

  file ::File.join(apache_dir, 'mods-available', "#{new_resource.name}.load") do
    content "LoadModule #{new_resource.identifier} #{new_resource.path}\n"
    mode '0644'
  end

  execute "a2enmod #{new_resource.name}" do
    command "/usr/sbin/a2enmod #{new_resource.name}"
    notifies new_resource.apache_service_notification, 'service[apache2]', :delayed
    not_if { mod_enabled?(new_resource) }
  end
end

action :disable do
  execute "a2dismod #{new_resource.name}" do
    command "/usr/sbin/a2dismod #{new_resource.name}"
    notifies new_resource.apache_service_notification, 'service[apache2]', :delayed
    only_if { mod_enabled?(new_resource) }
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
