#
# Cookbook:: apache2
# Attributes:: default
#
# Copyright:: 2008-2017, Chef Software, Inc.
# Copyright:: 2014, Viverae, Inc.
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

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default['apache']['default_site_port'] = '80'

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

  