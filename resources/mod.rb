include Apache2::Cookbook::Helpers

property :root_group, String,
         default: lazy { default_apache_root_group },
         description: 'Set to override the platforms default root group for the template file.'

action :create do
  template ::File.join(apache_dir, 'mods-available', "#{new_resource.name}.conf") do
    source "mods/#{new_resource.name}.conf.erb"
    cookbook 'apache2'
    owner 'root'
    group new_resource.root_group
    mode '0644'
    variables(
      apache_dir: apache_dir
    )
    notifies :reload, 'service[apache2]', :delayed
    action :create
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
