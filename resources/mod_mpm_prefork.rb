#
# Cookbook:: apache2
# Resource:: apache2_mod_mpm_prefork
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

property :startservers, Integer,
         default: 16,
         description: 'number of server processes to start'

property :minspareservers, Integer,
         default: 16,
         description: 'minimum number of server processes which are kept spare'

property :maxspareservers, Integer,
         default: 32,
         description: 'maximum number of server processes which are kept spare'

property :serverlimit, Integer,
         default: 256,
         description: ''

property :maxrequestworkers, Integer,
         default: 256,
         description: 'maximum number of server processes allowed to start'

property :maxconnectionsperchild, Integer,
         default: 10_000,
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_mom_prefork.conf') do
    source 'mods/prefork.conf.erb'
    cookbook 'apache2'
    variables(
      startservers: new_resource.startservers,
      minspareservers: new_resource.minspareservers,
      maxspareservers: new_resource.maxspareservers,
      serverlimit: new_resource.serverlimit,
      maxrequestworkers: new_resource.maxrequestworkers,
      maxconnectionsperchild: new_resource.maxconnectionsperchild
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
