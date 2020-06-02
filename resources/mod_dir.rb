unified_mode true

property :directory_index, Array,
         default: %w(
           index.html
           index.cgi
           index.pl
           index.php
           index.xhtml
           index.htm
         ),
         description: 'Array of directory indexes'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'dir.conf') do
    source 'mods/dir.conf.erb'
    cookbook 'apache2'
    variables(directory_index: new_resource.directory_index)
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
