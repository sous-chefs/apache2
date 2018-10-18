property :file_location, String, default: '/usr/local/bin/apache2_module_conf_generate.pl'

action :create do
  unless platform_family?('debian')
    cookbook_file new_resource.file_location do
      source 'apache2_module_conf_generate.pl'
      mode '0750'
      owner 'root'
      group new_resource.root_group
    end
  end
end

action :execute do
  execute 'generate-module-list' do
    command "#{new_resource.file_location} #{lib_dir} #{apache_dir}/mods-available"
    action :run
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
