unified_mode true

property :dav_lock_db, String,
         default: lazy { ::File.join(lock_dir, 'DAVLock') },
         description: 'LockDB file location.
Defaults to platform specific locations, see libraries/helpers.rb'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'dav_fs.conf') do
    source 'mods/dav_fs.conf.erb'
    cookbook 'apache2'
    variables(dav_lock_db: new_resource.dav_lock_db)
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
