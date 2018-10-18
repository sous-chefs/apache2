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

# Where the various parts of apache are
case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  if node['platform'] == 'amazon' && node['platform_version'] == 1
    default['apache']['package'] = 'httpd24'
    default['apache']['devel_package'] = 'httpd24-devel'
  else
    default['apache']['package'] = 'httpd'
    default['apache']['devel_package'] = 'httpd-devel'
  end
  default['apache']['dir']         = '/etc/httpd'
  default['apache']['conf_dir']    = '/etc/httpd/conf'
  default['apache']['docroot_dir'] = '/var/www/html'
  default['apache']['cgibin_dir']  = '/var/www/cgi-bin'
  default['apache']['run_dir']     = '/var/run/httpd'
when 'suse'
  default['apache']['package']     = 'apache2'
  default['apache']['devel_package'] = 'httpd-devel'
  default['apache']['dir']         = '/etc/apache2'
  default['apache']['conf_dir']    = '/etc/apache2'
  default['apache']['docroot_dir'] = '/srv/www/htdocs'
  default['apache']['cgibin_dir']  = '/srv/www/cgi-bin'
  default['apache']['run_dir']     = '/var/run/httpd'
when 'debian'
  default['apache']['package']     = 'apache2'
  default['apache']['devel_package'] =
    if node['apache']['mpm'] == 'prefork'
      'apache2-prefork-dev'
    else
      'apache2-dev'
    end
  default['apache']['dir']         = '/etc/apache2'
  default['apache']['conf_dir']    = '/etc/apache2'
  default['apache']['cgibin_dir']  = '/usr/lib/cgi-bin'
  default['apache']['run_dir']     = '/var/run/apache2'
  default['apache']['docroot_dir'] = '/var/www/html'
  default['apache']['build_dir'] = '/usr/share/apache2'
when 'arch'
  default['apache']['package'] = 'apache'
  default['apache']['dir']         = '/etc/httpd'
  default['apache']['conf_dir']    = '/etc/httpd'
  default['apache']['docroot_dir'] = '/srv/http'
  default['apache']['cgibin_dir']  = '/usr/share/httpd/cgi-bin'
  default['apache']['run_dir']     = '/var/run/httpd'
when 'freebsd'
  default['apache']['package']     = 'apache24'
  default['apache']['dir']         = '/usr/local/etc/apache24'
  default['apache']['conf_dir']    = '/usr/local/etc/apache24'
  default['apache']['docroot_dir'] = '/usr/local/www/apache24/data'
  default['apache']['cgibin_dir']  = '/usr/local/www/apache24/cgi-bin'
  default['apache']['run_dir']     = '/var/run'
  default['apache']['devel_package'] = 'httpd-devel'
else
  default['apache']['package'] = 'apache2'
  default['apache']['devel_package'] = 'apache2-dev'
  default['apache']['dir']         = '/etc/apache2'
  default['apache']['conf_dir']    = '/etc/apache2'
  default['apache']['docroot_dir'] = '/var/www'
  default['apache']['cgibin_dir']  = '/usr/lib/cgi-bin'
  default['apache']['run_dir']     = 'logs'
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default['apache']['listen']            = ['*:80']
default['apache']['contact']           = 'ops@example.com'
default['apache']['timeout']           = 300
default['apache']['keepalive']         = 'On'
default['apache']['keepaliverequests'] = 100
default['apache']['keepalivetimeout']  = 5
default['apache']['locale'] = 'C'
default['apache']['sysconfig_additional_params'] = {}
default['apache']['default_site_enabled'] = false
default['apache']['default_site_port']    = '80'
default['apache']['access_file_name'] = '.htaccess'
default['apache']['default_release'] = nil

# Security
default['apache']['servertokens']    = 'Prod'
default['apache']['serversignature'] = 'On'
default['apache']['traceenable']     = 'Off'

# mod_status Allow list, space seprated list of allowed entries.
default['apache']['status_allow_list'] = '127.0.0.1 ::1'

# mod_status ExtendedStatus, set to 'true' to enable
default['apache']['ext_status'] = false

# mod_info Allow list, space seprated list of allowed entries.
default['apache']['info_allow_list'] = '127.0.0.1 ::1'

# Prefork Attributes
default['apache']['prefork']['startservers']        = 16
default['apache']['prefork']['minspareservers']     = 16
default['apache']['prefork']['maxspareservers']     = 32
default['apache']['prefork']['serverlimit']         = 256
default['apache']['prefork']['maxrequestworkers']   = 256
default['apache']['prefork']['maxconnectionsperchild'] = 10_000

# Worker Attributes
default['apache']['worker']['startservers']        = 4
default['apache']['worker']['serverlimit']         = 16
default['apache']['worker']['minsparethreads']     = 64
default['apache']['worker']['maxsparethreads']     = 192
default['apache']['worker']['threadlimit']         = 192
default['apache']['worker']['threadsperchild']     = 64
default['apache']['worker']['maxrequestworkers']   = 1024
default['apache']['worker']['maxconnectionsperchild'] = 0

# Event Attributes
default['apache']['event']['startservers']        = 4
default['apache']['event']['serverlimit']         = 16
default['apache']['event']['minsparethreads']     = 64
default['apache']['event']['maxsparethreads']     = 192
default['apache']['event']['threadlimit']         = 192
default['apache']['event']['threadsperchild']     = 64
default['apache']['event']['maxrequestworkers']   = 1024
default['apache']['event']['maxconnectionsperchild'] = 0

# mod_proxy settings
default['apache']['proxy']['require']    = 'all denied'
default['apache']['proxy']['order']      = 'deny,allow'
default['apache']['proxy']['deny_from']  = 'all'
default['apache']['proxy']['allow_from'] = 'none'
