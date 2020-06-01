unified_mode true

property :info_allow_list, [String, Array],
         default: %w(127.0.0.1 ::1),
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'info.conf') do
    source 'mods/info.conf.erb'
    cookbook 'apache2'
    variables(info_allow_list: Array(new_resource.info_allow_list))
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
