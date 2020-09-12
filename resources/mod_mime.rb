unified_mode true

property :types_config, String,
         default: lazy { default_types_config },
         description: ''

property :add_type, Hash,
         default: {
           1 => 'text/html .shtml',
           2 => 'application/x-compress .Z',
           3 => 'application/x-gzip .gz .tgz',
           4 => 'application/x-bzip2 .bz2',
           5 => 'image/svg+xml svg svgz',
         },
         description: ''

property :add_handler, Hash,
         default: { 1 => 'AddHandler type-map var' },
         description: ''

property :add_output_filter, Hash,
         default: { 1 => 'INCLUDES .shtml' },
         description: ''

property :add_encoding, Hash,
         default: { 1 => 'gzip svgz' },
         description: ''

property :add_language, Hash,
         default: {},
         description: 'Not currently used'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mime.conf') do
    source 'mods/mime.conf.erb'
    cookbook 'apache2'
    variables(
      types_config: new_resource.types_config,
      add_type: new_resource.add_type,
      add_handler: new_resource.add_handler,
      add_output_filter: new_resource.add_output_filter,
      add_encoding: new_resource.add_encoding
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
