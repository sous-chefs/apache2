#
# Cookbook:: apache2
# Resource:: apache_mod
#
# Copyright:: 2008-2017, Chef Software, Inc.
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

property :root_group, String,
         default: lazy { default_apache_root_group },
         description: 'Set to override the default root group'
property :identify, String,
         default: lazy { "#{name}_module" },
         description: 'String to identify the module for the `LoadModule` directive'

action :create do
  template ::File.join(apache_dir, 'mods-available', "#{new_resource.name}.conf") do
    source "mods/#{new_resource.name}.conf.erb"
    cookbook 'apache2'
    owner 'root'
    group new_resource.root_group
    mode '0644'
    variables(
      apache_dir: apache_dir
    )
    notifies :reload, 'service[apache2]', :delayed
    action :create
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
