# frozen_string_literal: true

provides :apache2_mod_include
unified_mode true

property :add_type, Hash,
         default: { 1 => 'text/html .shtml' },
         description: 'Value for the Apache AddType directive.'

property :add_output_filter, Hash,
         default: { 1 => 'INCLUDES .shtml' },
         description: 'Value for the Apache AddOutputFilter directive.'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'include.conf') do
    source 'mods/include.conf.erb'
    cookbook 'apache2'
    variables(
      add_type: new_resource.add_type,
      add_output_filter: new_resource.add_output_filter
    )
  end
end

action :delete do
  remove_module_configuration 'include'
end

action_class do
  include Apache2::Cookbook::Helpers
end
