unified_mode true

property :proxy_ftp_dir_charset, String,
         default: 'UTF-8',
         description: ''

property :proxy_ftp_escape_wildcards, String,
         equal_to: ['on', 'off', ''],
         default: ''

property :proxy_ftp_list_on_wildcard, String,
         equal_to: ['on', 'off', ''],
         default: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'proxy_ftp.conf') do
    source 'mods/proxy_ftp.conf.erb'
    cookbook 'apache2'
    variables(
      proxy_ftp_dir_charset: new_resource.proxy_ftp_dir_charset,
      proxy_ftp_escape_wildcards: new_resource.proxy_ftp_escape_wildcards,
      proxy_ftp_list_on_wildcard: new_resource.proxy_ftp_list_on_wildcard
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
