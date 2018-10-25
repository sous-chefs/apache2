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
action :enable do
  execute "a2ensite #{new_resource.name}" do
    command "/usr/sbin/a2ensite #{new_resource.name}"
    notifies :reload, 'service[apache2]', :delayed
    not_if { site_enabled?(new_resource) }
    only_if { site_available?(new_resource) }
  end
end

action :disable do
  execute "a2dissite #{new_resource.name}" do
    command "/usr/sbin/a2dissite #{new_resource.name}"
    notifies :reload, 'service[apache2]', :delayed
    only_if { site_enabled?(new_resource) }
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
