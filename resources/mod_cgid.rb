unified_mode true

property :script_sock, String,
         default: lazy { ::File.join(default_run_dir, 'cgisock') }

action :create do
  template ::File.join(apache_dir, 'mods-available', 'cgid.conf') do
    source 'mods/cgid.conf.erb'
    cookbook 'apache2'
    variables(script_sock: new_resource.script_sock)
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
