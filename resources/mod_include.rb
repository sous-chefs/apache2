unified_mode true

property :add_type, Hash,
         default: { 1 => 'text/html .shtml' },
         description: ''

property :add_output_filter, Hash,
         default: { 1 => 'INCLUDES .shtml' },
         description: ''

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

action_class do
  include Apache2::Cookbook::Helpers
end
