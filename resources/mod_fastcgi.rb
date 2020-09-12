unified_mode true

property :fast_cgi_wrapper, String,
         default: '',
         description: 'Defaults to an empty string'

property :add_handler, Hash,
         default: { 1 => 'fastcgi-script .fcgi' },
         description: 'A key ordered hash of handlers'

property :fast_cgi_ipc_dir, String,
         default: lazy { ::File.join(lib_dir, 'fastcgi') },
         description: 'FastCGI directory.
Defaults to platform specific locations, see libraries/helpers.rb'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'fastcgi.conf') do
    source 'mods/fastcgi.conf.erb'
    cookbook 'apache2'
    variables(
      fast_cgi_wrapper: new_resource.fast_cgi_wrapper,
      add_handler: new_resource.add_handler,
      fast_cgi_ipc_dir: new_resource.fast_cgi_ipc_dir
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
