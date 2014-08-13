# encoding: utf-8
#
# Cookbook Name:: apache2
# Providers:: site
#
# Copyright 2012-2014, Opscode, Inc.
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

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do
  execute "a2ensite #{new_resource.name}" do
    command "/usr/sbin/a2ensite #{new_resource.name}"
    only_if { ::File.exist?("#{node['apache']['dir']}/sites-available/#{new_resource.name}") }
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  execute "a2dissite #{new_resource.name}" do
    command "/usr/sbin/a2dissite #{new_resource.name}"
    only_if { ::File.exist?("#{node['apache']['dir']}/sites-enabled/#{new_resource.name}") }
  end

  new_resource.updated_by_last_action(true)
end
