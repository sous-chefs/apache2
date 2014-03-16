#
# Cookbook Name:: apache2
# Recipe:: ohai_plugin
#
# Based on https://github.com/opscode-cookbooks/nginx/blob/master/recipes/ohai_plugin.rb
# Copyright 2014, Onddo Labs, Sl.
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

ohai 'reload_apache' do
  plugin 'apache'
  action :nothing
end

template "#{node['ohai']['plugin_path']}/apache.rb" do
  source 'plugins/apache.rb.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  notifies :reload, 'ohai[reload_apache]', :immediately
end

include_recipe 'ohai::default'
