#
# Cookbook Name:: apache2_test
# Recipe:: mod_authz_listed_host
#
# Copyright 2012, Opscode, Inc.
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
extend Apache2::Helpers
include_recipe 'apache2::default'
include_recipe 'apache2::mod_authz_host'

name = /([^\/]*)\.rb$/.match(__FILE__)[1]
docroot = "#{node['apache_test']['root_dir']}/#{name}"

directory docroot do
  action :create
end

file "#{docroot}/index.html" do
  content "Hello #{name}"
  action :create
end

template_variables = basic_web_app(name, docroot)
template_variables['locations'] = {
  '/' => {
    'Deny' => 'from all',
    'Allow from' => node['apache_test']['remote_host_ip']
  }
}

apache2_web_app name do
  variables template_variables
  action [:create, :enable]
  notifies :reload, 'service[apache2]'
end
