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
property :startservers, Integer,
         default: 4,
         description: ''

property :serverlimit, Integer,
         default: 16,
         description: ''

property :minsparethreads, Integer,
         default: 64,
         description: ''

property :maxsparethreads, Integer,
         default: 192,
         description: ''

property :threadlimit, Integer,
         default: 192,
         description: ''

property :threadsperchild, Integer,
         default: 64,
         description: ''

property :maxrequestworkers, Integer,
         default: 1024,
         description: ''

property :maxconnectionsperchild, Integer,
         default: 0,
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mpm_event.conf') do
    source 'mods/mpm_event.conf.erb'
    cookbook 'apache2'
    variables(
      startservers:  new_resource.startservers,
      serverlimit:  new_resource.serverlimit,
      minsparethreads:  new_resource.minsparethreads,
      maxsparethreads:  new_resource.maxsparethreads,
      threadlimit:  new_resource.threadlimit,
      threadsperchild:  new_resource.threadsperchild,
      maxrequestworkers:  new_resource.maxrequestworkers,
      maxconnectionsperchild:  new_resource.maxconnectionsperchild
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
