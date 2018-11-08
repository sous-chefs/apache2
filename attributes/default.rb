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
default['apache']['listen']            = ['*:80']
default['apache']['contact']           = 'ops@example.com'
default['apache']['timeout']           = 300
default['apache']['locale'] = 'C'
default['apache']['sysconfig_additional_params'] = {}
default['apache']['default_site_enabled'] = false
default['apache']['default_site_port']    = '80'
default['apache']['access_file_name'] = '.htaccess'

# Security
default['apache']['servertokens']    = 'Prod'
default['apache']['serversignature'] = 'On'
default['apache']['traceenable']     = 'Off'

# mod_status ExtendedStatus, set to 'true' to enable
default['apache']['ext_status'] = false
