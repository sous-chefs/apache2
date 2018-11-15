#
# Cookbook:: apache2
# Resource:: apache2_mod_proxy_ftp
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
