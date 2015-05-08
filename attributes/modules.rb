#
# Cookbook Name:: apache2
# Attributes:: modules
#
# Copyright 2008-2013, Chef Software, Inc.
# Copyright 2014, Viverae, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Which modules have custom recipes?
default['apache']['modules']['access_compat']['has_recipe'] = true
default['apache']['modules']['actions']['has_recipe'] = true
default['apache']['modules']['alias']['has_recipe'] = true
default['apache']['modules']['allowmethods']['has_recipe'] = true
default['apache']['modules']['apreq2']['has_recipe'] = true
default['apache']['modules']['asis']['has_recipe'] = true
default['apache']['modules']['auth_basic']['has_recipe'] = true
default['apache']['modules']['auth_cas']['has_recipe'] = true
default['apache']['modules']['auth_digest']['has_recipe'] = true
default['apache']['modules']['auth_form']['has_recipe'] = true
default['apache']['modules']['auth_openid']['has_recipe'] = true
default['apache']['modules']['authn_anon']['has_recipe'] = true
default['apache']['modules']['authn_core']['has_recipe'] = true
default['apache']['modules']['authn_dbd']['has_recipe'] = true
default['apache']['modules']['authn_dbm']['has_recipe'] = true
default['apache']['modules']['authn_file']['has_recipe'] = true
default['apache']['modules']['authn_socache']['has_recipe'] = true
default['apache']['modules']['authnz_ldap']['has_recipe'] = true
default['apache']['modules']['authz_core']['has_recipe'] = true
default['apache']['modules']['authz_dbd']['has_recipe'] = true
default['apache']['modules']['authz_dbm']['has_recipe'] = true
default['apache']['modules']['authz_default']['has_recipe'] = true
default['apache']['modules']['authz_groupfile']['has_recipe'] = true
default['apache']['modules']['authz_host']['has_recipe'] = true
default['apache']['modules']['authz_owner']['has_recipe'] = true
default['apache']['modules']['authz_user']['has_recipe'] = true
default['apache']['modules']['autoindex']['has_recipe'] = true
default['apache']['modules']['buffer']['has_recipe'] = true
default['apache']['modules']['cache']['has_recipe'] = true
default['apache']['modules']['cache_disk']['has_recipe'] = true
default['apache']['modules']['cache_socache']['has_recipe'] = true
default['apache']['modules']['cgi']['has_recipe'] = true
default['apache']['modules']['cgid']['has_recipe'] = true
default['apache']['modules']['charset_lite']['has_recipe'] = true
default['apache']['modules']['cloudflare']['has_recipe'] = true
default['apache']['modules']['data']['has_recipe'] = true
default['apache']['modules']['dav']['has_recipe'] = true
default['apache']['modules']['dav_fs']['has_recipe'] = true
default['apache']['modules']['dav_lock']['has_recipe'] = true
default['apache']['modules']['dav_svn']['has_recipe'] = true
default['apache']['modules']['dbd']['has_recipe'] = true
default['apache']['modules']['deflate']['has_recipe'] = true
default['apache']['modules']['dialup']['has_recipe'] = true
default['apache']['modules']['dir']['has_recipe'] = true
default['apache']['modules']['dump_io']['has_recipe'] = true
default['apache']['modules']['echo']['has_recipe'] = true
default['apache']['modules']['env']['has_recipe'] = true
default['apache']['modules']['expires']['has_recipe'] = true
default['apache']['modules']['ext_filter']['has_recipe'] = true
default['apache']['modules']['fastcgi']['has_recipe'] = true
default['apache']['modules']['fcgid']['has_recipe'] = true
default['apache']['modules']['file_cache']['has_recipe'] = true
default['apache']['modules']['filter']['has_recipe'] = true
default['apache']['modules']['headers']['has_recipe'] = true
default['apache']['modules']['heartbeat']['has_recipe'] = true
default['apache']['modules']['heartmonitor']['has_recipe'] = true
default['apache']['modules']['include']['has_recipe'] = true
default['apache']['modules']['info']['has_recipe'] = true
default['apache']['modules']['jk']['has_recipe'] = true
default['apache']['modules']['lbmethod_bybusyness']['has_recipe'] = true
default['apache']['modules']['lbmethod_byrequests']['has_recipe'] = true
default['apache']['modules']['lbmethod_bytraffic']['has_recipe'] = true
default['apache']['modules']['lbmethod_heartbeat']['has_recipe'] = true
default['apache']['modules']['log_config']['has_recipe'] = true
default['apache']['modules']['log_debug']['has_recipe'] = true
default['apache']['modules']['log_forensic']['has_recipe'] = true
default['apache']['modules']['logio']['has_recipe'] = true
default['apache']['modules']['lua']['has_recipe'] = true
default['apache']['modules']['macro']['has_recipe'] = true
default['apache']['modules']['mime']['has_recipe'] = true
default['apache']['modules']['mime_magic']['has_recipe'] = true
default['apache']['modules']['negotiation']['has_recipe'] = true
default['apache']['modules']['pagespeed']['has_recipe'] = true
default['apache']['modules']['perl']['has_recipe'] = true
default['apache']['modules']['php5']['has_recipe'] = true
default['apache']['modules']['proxy']['has_recipe'] = true
default['apache']['modules']['proxy_ajp']['has_recipe'] = true
default['apache']['modules']['proxy_balancer']['has_recipe'] = true
default['apache']['modules']['proxy_connect']['has_recipe'] = true
default['apache']['modules']['proxy_express']['has_recipe'] = true
default['apache']['modules']['proxy_fcgi']['has_recipe'] = true
default['apache']['modules']['proxy_fdpass']['has_recipe'] = true
default['apache']['modules']['proxy_ftp']['has_recipe'] = true
default['apache']['modules']['proxy_html']['has_recipe'] = true
default['apache']['modules']['proxy_http']['has_recipe'] = true
default['apache']['modules']['proxy_scgi']['has_recipe'] = true
default['apache']['modules']['proxy_wstunnel']['has_recipe'] = true
default['apache']['modules']['python']['has_recipe'] = true
default['apache']['modules']['ratelimit']['has_recipe'] = true
default['apache']['modules']['reflector']['has_recipe'] = true
default['apache']['modules']['remoteip']['has_recipe'] = true
default['apache']['modules']['reqtimeout']['has_recipe'] = true
default['apache']['modules']['request']['has_recipe'] = true
default['apache']['modules']['rewrite']['has_recipe'] = true
default['apache']['modules']['sed']['has_recipe'] = true
default['apache']['modules']['session']['has_recipe'] = true
default['apache']['modules']['session_cookie']['has_recipe'] = true
default['apache']['modules']['session_crypto']['has_recipe'] = true
default['apache']['modules']['session_dbd']['has_recipe'] = true
default['apache']['modules']['setenvif']['has_recipe'] = true
default['apache']['modules']['slotmem_plain']['has_recipe'] = true
default['apache']['modules']['slotmem_shm']['has_recipe'] = true
default['apache']['modules']['socache_dbm']['has_recipe'] = true
default['apache']['modules']['socache_memcache']['has_recipe'] = true
default['apache']['modules']['socache_shmcb']['has_recipe'] = true
default['apache']['modules']['speling']['has_recipe'] = true
default['apache']['modules']['ssl']['has_recipe'] = true
default['apache']['modules']['status']['has_recipe'] = true
default['apache']['modules']['substitute']['has_recipe'] = true
default['apache']['modules']['suexec']['has_recipe'] = true
default['apache']['modules']['systemd']['has_recipe'] = true
default['apache']['modules']['unique_id']['has_recipe'] = true
default['apache']['modules']['unixd']['has_recipe'] = true
default['apache']['modules']['userdir']['has_recipe'] = true
default['apache']['modules']['usertrack']['has_recipe'] = true
default['apache']['modules']['vhost_alias']['has_recipe'] = true
default['apache']['modules']['wsgi']['has_recipe'] = true
default['apache']['modules']['xml2enc']['has_recipe'] = true
default['apache']['modules']['xsendfile']['has_recipe'] = true

# Prefix for module names
case node['platform']
when 'redhat', 'centos', 'scientific', 'fedora', 'amazon', 'oracle'
  default['apache']['modules']['package_prefix'] = 'mod_'
  if node['platform'] == 'amazon'
    if node['apache']['version'] == '2.4'
      default['apache']['modules']['package_prefix'] = 'mod24_'
      default['apache']['modules']['auth_kerb']['install_package'] = true
      default['apache']['modules']['dav_svn']['install_package'] = true
      default['apache']['modules']['fcgid']['install_package'] = true
      default['apache']['modules']['geoip']['install_package'] = true
      default['apache']['modules']['ldap']['install_package'] = true
      default['apache']['modules']['nss']['install_package'] = true
      default['apache']['modules']['php5']['install_package'] = false
      default['apache']['modules']['php5']['filename'] = 'libphp.so'
      default['apache']['modules']['proxy_html']['install_package'] = false
      default['apache']['modules']['perl']['install_package'] = true
      default['apache']['modules']['security']['install_package'] = true
      default['apache']['modules']['session']['install_package'] = true
      default['apache']['modules']['ssl']['install_package'] = true
      default['apache']['modules']['wsgi']['install_package'] = true
      if node['platform_version'] < '2015.03'
        default['apache']['modules']['wsgi']['package_name'] = 'mod24_wsgi-python26.x86_64'
      else
        default['apache']['modules']['wsgi']['package_name'] = 'mod24_wsgi-python27.x86_64'
      end
    end
  end
when 'suse', 'opensuse'
  default['apache']['modules']['package_prefix'] = 'apache2-mod_'
when 'debian', 'ubuntu'
  default['apache']['modules']['package_prefix'] = 'libapache2-mod-'
when 'freebsd'
  if node['apache']['version'] == '2.4'
    default['apache']['modules']['package_prefix'] = 'app24-mod_'
  else
    default['apache']['modules']['package_prefix'] = 'app22-mod_'
  end
else
  default['apache']['modules']['package_prefix'] = 'mod_'
end

# Default modules to enable via include_recipe
default['apache']['default_modules'] = %w(
  status alias auth_basic authn_core authn_file authz_core authz_groupfile
  authz_host authz_user autoindex dir env mime negotiation setenvif
)

%w(log_config logio).each do |log_mod|
  default['apache']['default_modules'] << log_mod if %w(rhel fedora suse arch freebsd).include?(node['platform_family'])
end

if node['apache']['version'] == '2.4'
  %w(unixd).each do |unix_mod|
    default['apache']['default_modules'] << unix_mod if %w(rhel fedora suse arch freebsd).include?(node['platform_family'])
  end

  unless node['platform'] == 'amazon'
    default['apache']['default_modules'] << 'systemd' if %w(rhel fedora).include?(node['platform_family'])
  end
end
