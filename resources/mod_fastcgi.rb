#
# Cookbook:: apache2
# Resource:: apache2_conf
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

property :fast_cgi_wrapper, String,
         default: '',
         description: 'Defaults to an empty string'

property :add_handler, Hash,
         default: {
           1 => 'fastcgi-script .fcgi',
         },
         description: ''

property :fast_cgi_ipc_dir, String,
         default: lazy { ::File.join(lib_dir, 'fastcgi') },
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_fastcgi.conf') do
    source 'mods/fastcgi.conf.erb'
    cookbook 'apache2'
    variables(
      fast_cgi_wrapper: new_resource.fast_cgi_wrapper,
      add_handler: new_resource.add_handler,
      fast_cgi_ipc_dir: new_resource.fast_cgi_ipc_dir
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
