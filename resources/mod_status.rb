#
# Cookbook:: apache2
# Resource:: apache2_mod_status
#
# Copyright:: 2008-2017, Chef Software, Inc.
# Copyright:: 2018, Webb Agile Solutions Ltd.
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
include Apache2::Cookbook::Helpers

property :location, String,
         default: '/server-status'
property :status_allow_list, String,
         default: '127.0.0.1 ::1',
         description: 'Clients in the specified IP address ranges can access the resource. For full description see https://httpd.apache.org/docs/2.4/mod/mod_authz_core.html#require'
property :extended_status, String,
         equal_to: %w(On Off),
         description: 'For info see: https://httpd.apache.org/docs/current/mod/mod_status.html',
         default: 'Off'
property :proxy_status, String,
         equal_to: %w(On Off),
         default: 'On',
         description: 'For info see: https://httpd.apache.org/docs/current/mod/mod_status.html'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_status.conf') do
    source 'mods/alias.conf.erb'
    cookbook 'apache2'
    variables(
      location: new_resource.location,
      status_allow_list: new_resource.status_allow_list,
      extended_status: new_resource.extended_status,
      proxy_status: new_resource.proxy_status
    )
  end
end
