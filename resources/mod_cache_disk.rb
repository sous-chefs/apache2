unified_mode true

property :cache_root, String,
         default: lazy { default_cache_root },
         description: 'Root directory to keep the cache.
Defaults to platform specific locations, see libraries/helpers.rb'

property :cache_dir_levels, String,
         default: '2',
         description: 'https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html#cachedirlevels'

property :cache_dir_length, String,
         default: '2',
         description: 'https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html#cachedirlength'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'cache_disk.conf') do
    source 'mods/cache_disk.conf.erb'
    cookbook 'apache2'
    variables(
      cache_root: new_resource.cache_root,
      cache_dir_levels: new_resource.cache_dir_levels,
      cache_dir_length: new_resource.cache_dir_length
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
