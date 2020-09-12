unified_mode true

property :options, Array,
         default: %w(Indexes MultiViews SymLinksIfOwnerMatch),
         description: 'Alias options'

property :icondir, String,
         default: lazy { icon_dir },
         description: 'The icon directory
Defaults to platform specific locations, see libraries/helpers.rb'

property :allow_override, Array,
         default: %w(None),
         description: 'For full description see https://httpd.apache.org/docs/2.4/mod/core.html#allowoverride'

property :require, String,
         default: 'all granted',
         description: 'For full description see https://httpd.apache.org/docs/2.4/mod/mod_authz_core.html#require'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'alias.conf') do
    source 'mods/alias.conf.erb'
    cookbook 'apache2'
    variables(
      icondir: new_resource.icondir,
      options: new_resource.options,
      allow_override: new_resource.allow_override,
      require: new_resource.require
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
