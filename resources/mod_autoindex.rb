unified_mode true

property :index_options, Array,
         default: %w(FancyIndexing VersionSort HTMLTable NameWidth=* DescriptionWidth=* Charset=UTF-8),
         description: 'An array of directory indexing options. For more inforamtion see https://httpd.apache.org/docs/2.4/mod/mod_autoindex.html#indexoptions'

property :readme_name, String,
         default: 'README.html',
         description: 'Name of the file that will be inserted at the end of the index listing. For more information see https://httpd.apache.org/docs/2.4/mod/mod_autoindex.html#readmename'

property :header_name, String,
         default: 'HEADER.html',
         description: 'Header name. For more information see https://httpd.apache.org/docs/2.4/mod/mod_autoindex.html#headername'

property :index_ignore, String,
         default: '.??* *~ *# RCS CVS *,v *,t',
         description: 'Adds to the list of files to hide when listing a directory. For more information see https://httpd.apache.org/docs/2.4/mod/mod_autoindex.html#indexignore'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'autoindex.conf') do
    source 'mods/autoindex.conf.erb'
    cookbook 'apache2'
    variables(
      header_name: new_resource.header_name,
      index_options: new_resource.index_options,
      index_ignore: new_resource.index_ignore,
      readme_name: new_resource.readme_name
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
