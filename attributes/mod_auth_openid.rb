# mod_auth_openids
default['apache']['mod_auth_openid']['ref']        = 'v0.8'
default['apache']['mod_auth_openid']['version']    = '0.8'
default['apache']['mod_auth_openid']['source_url'] = "https://github.com/bmuller/mod_auth_openid/archive/#{node['apache']['mod_auth_openid']['ref']}.tar.gz"
default['apache']['mod_auth_openid']['cache_dir']  = '/var/cache/mod_auth_openid'
default['apache']['mod_auth_openid']['dblocation'] = "#{node['apache']['mod_auth_openid']['cache_dir']}/mod_auth_openid.db"

default['apache']['mod_auth_openid']['configure_flags'] =
  case node['platform_family']
  when 'freebsd'
    [
      'CPPFLAGS=-I/usr/local/include',
      'LDFLAGS=-I/usr/local/lib -lsqlite3',
    ]
  else
    []
  end
