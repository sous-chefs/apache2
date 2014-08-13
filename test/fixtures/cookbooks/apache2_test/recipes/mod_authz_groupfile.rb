#
# Cookbook Name:: apache2_test
# Recipe:: mod_authz_groupfile
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
include_recipe 'apache2::mod_authz_groupfile'

name = /([^\/]*)\.rb$/.match(__FILE__)[1]
docroot = "#{node['apache_test']['root_dir']}/#{name}"

directory docroot do
  action :create
end

file "#{docroot}/index.html" do
  content "Hello #{name}"
  action :create
end

package 'apache2-utils' if platform_family?('debian', 'suse') && node['apache']['version'] == '2.4'
bash 'add-credentials' do
  case node['platform_family']
  when 'suse'
    code %Q{
      htpasswd2 -b -c #{node['apache_test']['root_dir']}/.htpasswd #{node['apache_test']['auth_username']} #{node['apache_test']['auth_password']}
      htpasswd2 -b #{node['apache_test']['root_dir']}/.htpasswd meatballs secret
    }
  else
    code %Q{
      htpasswd -b -c #{node['apache_test']['root_dir']}/.htpasswd #{node['apache_test']['auth_username']} #{node['apache_test']['auth_password']}
      htpasswd -b #{node['apache_test']['root_dir']}/.htpasswd meatballs secret
    }
  end
  action :run
end

file "#{node['apache_test']['root_dir']}/.htgroups" do
  content "#{node['apache_test']['auth_group']}: #{node['apache_test']['auth_username']}"
end

template_variables = basic_web_app(name, docroot)
template_variables['locations'] = {
  '/' => {
    'AuthUserFile' => "#{node['apache_test']['root_dir']}/.htpasswd",
    'AuthGroupFile' => "#{node['apache_test']['root_dir']}/.htgroups",
    'AuthType' => 'basic',
    'AuthDigestDomain' => '/',
    'AuthName' => '"private area"',
    'Require group' => node['apache_test']['auth_group']
  }
}

apache2_web_app name do
  variables template_variables
  action [:create, :enable]
  notifies :reload, 'service[apache2]'
end
