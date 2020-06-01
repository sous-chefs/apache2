unified_mode true

property :add_output_filter_by_type, Hash,
         default: {
           1 => 'DEFLATE text/html text/plain text/xml',
           2 => 'DEFLATE text/css',
           3 => 'DEFLATE application/x-javascript application/javascript application/ecmascript',
           4 => 'DEFLATE application/rss+xml',
           5 => 'DEFLATE application/xml',
           6 => 'DEFLATE application/xhtml+xml',
           7 => 'DEFLATE image/svg+xml',
           8 => 'DEFLATE application/atom_xml',
           9 => 'DEFLATE application/x-httpd-php',
           10 => 'DEFLATE application/x-httpd-fastphp',
           11 => 'DEFLATE application/x-httpd-eruby',
         },
         description: 'A hash of output filters, ordered by key number'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'deflate.conf') do
    source 'mods/deflate.conf.erb'
    cookbook 'apache2'
    variables(add_output_filter_by_type: new_resource.add_output_filter_by_type)
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
