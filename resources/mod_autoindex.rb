include Apache2::Cookbook::Helpers

property :index_options, Array,
         default: %w(FancyIndexing VersionSort HTMLTable NameWidth=* DescriptionWidth=* Charset=UTF-8),
         description: ''

property :readme_name, String,
         default: 'README.html',
         description: ''

property :header_name, String,
         default: 'HEADER.html',
         description: ''

property :index_ignore, String,
         default: '.??* *~ *# RCS CVS *,v *,t',
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'autoindex.conf') do
    source 'mods/autoindex.conf.erb'
    cookbook 'apache2'
    variables(
      index_options: new_resource.index_options,
      readme_name: new_resource.readme_name,
      header_name: new_resource.header_name,
      index_ignore: new_resource.index_ignore
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
