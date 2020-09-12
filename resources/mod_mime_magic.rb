unified_mode true

property :mime_magic_file, String,
         default: lazy { default_mime_magic_file },
         description: 'The location of the mime magic file
Defaults to platform specific locations, see libraries/helpers.rb'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mime_magic.conf') do
    source 'mods/mime_magic.conf.erb'
    cookbook 'apache2'
    variables(mime_magic_file: new_resource.mime_magic_file)
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
