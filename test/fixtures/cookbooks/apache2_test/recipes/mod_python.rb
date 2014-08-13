#
# Cookbook Name:: apache2_test
# Recipe:: mod_python
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
if node['apache']['version'] == '2.4' && %w(rhel fedora).include?(node['platform_family'])
  Chef::Log.warn('The rhel and fedora platforms do not have a package for mod_python. This cookbook will not attempt to test compatability.')
else
  extend Apache2::Helpers
  include_recipe 'apache2::default'
  if platform_family?('rhel', 'fedora')
    include_recipe 'yum-epel'
  end
  include_recipe 'apache2::mod_python'

  name = /([^\/]*)\.rb$/.match(__FILE__)[1]
  docroot = "#{node['apache_test']['root_dir']}/#{name}"

  directory docroot do
    action :create
  end

  file "#{docroot}/index.html" do
    content "Hello #{name}"
    action :create
  end

  file "#{docroot}/index.py" do
    content %q{
  #!/usr/bin/python
  import sys
  sys.stderr = sys.stdout
  import os
  from cgi import escape

  print "Content-type: text/plain"
  print
  for k in sorted(os.environ):
    print "%s=%s" %(escape(k), escape(os.environ[k]))
  }.strip
    mode '0755'
    action :create
  end

  template_variables = basic_web_app(name, docroot)
  template_variables['directory_index'] = ['index.py']
  template_variables['directories'] = {
    docroot => {
      'AllowOverride' => 'None',
      'AddHandler' => 'mod_python .py',
      'PythonHandler' => 'mod_python.cgihandler',
      'PythonDebug' => 'on',
      'Order' => 'allow,deny',
      'Allow' => 'from all'
    },
    '/' => {
      'Options' => 'FollowSymLinks',
      'AllowOverride' => 'None'
    }
  }

  apache2_web_app name do
    variables template_variables
    action [:create, :enable]
    notifies :reload, 'service[apache2]'
  end
end
