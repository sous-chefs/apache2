#
# Cookbook:: apache2
# Resource:: apache2_mod_proxy
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
property :proxy_requests, String,
         default: 'Off',
         description: ''

property :require, String,
         default: '',
         description: ''

property :add_default_charset, String,
         default: 'off',
         description: ''

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
