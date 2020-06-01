unified_mode true

property :proxy_requests, String,
         default: 'Off',
         description: ''

property :require, String,
         default: 'all denied',
         description: '[See mod_proxy access](https://httpd.apache.org/docs/trunk/mod/mod_proxy.html#access)'

property :add_default_charset, String,
         default: 'off',
         description: 'Add the default Charachter set'

property :proxy_via, String,
         equal_to: %w( Off On Full Block ),
         default: 'On',
         description: 'Enable/disable the handling of HTTP/1.1 "Via:" headers.'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'proxy.conf') do
    source 'mods/proxy.conf.erb'
    cookbook 'apache2'
    variables(
      proxy_requests: new_resource.proxy_requests,
      require: new_resource.require,
      add_default_charset: new_resource.add_default_charset,
      proxy_via: new_resource.proxy_via
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
