#
# Cookbook Name:: apache2
# Recipe:: windows
#
# Copyright 2008-2009, Opscode, Inc.
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

include_recipe "windows::default"

install_dir = File.expand_path(node['apache']['dir']).gsub('/', '\\')
windows_package node['apache']['windows']['display_name'] do
  source node['apache']['windows']['source']
  installer_type :msi

  # The latter four of these options are just to keep the Apache2 service
  # from failing before rendering the actual httpd.conf.
  options %W[
          /quiet
          INSTALLDIR="#{install_dir}"
          ALLUSERS=1
          SERVERADMIN=foo@example.com
          SERVERDOMAIN=example.com
          SERVERNAME=bar
  ].join(" ")
end

# Ensure that all of the directories exist and that Apache can touch them
%w{ dir log_dir conf_dir bin_dir cache_dir ssl_dir }.each do |dir|
  directory node['apache'][dir]
end

# Allow Debian style module and site management
%w{ sites-available sites-enabled mods-available mods-enabled }.each do |dir|
  directory "#{node['apache']['dir']}/#{dir}"
end

%w{a2ensite a2dissite a2enmod a2dismod}.each do |modscript|
  template "#{node['apache']['bin_dir']}/#{modscript}" do
    source "#{modscript}.erb"
  end
end

# Creates module.load files
cookbook_file "#{node['apache']['bin_dir']}/apache2_module_conf_generate.pl" do
  source "apache2_module_conf_generate.pl"
end

execute "generate-module-list" do
  command "#{node['apache']['bin_dir']}/apache2_module_conf_generate.pl #{node['apache']['lib_dir']} #{node['apache']['dir']}/mods-available"
  action :nothing
end

template "apache2.conf" do
  path node['apache']['conf']
  source "apache2.conf.erb"
  notifies :restart, "service[apache2]"
end

%w[security charset].each do |name|
  template "apache2-conf-#{name}" do
    path "#{node['apache']['conf_dir']}/#{name}"
    source "#{name}.erb"
    notifies :restart, "service[apache2]"
  end
end

template "#{node['apache']['dir']}/ports.conf" do
  source "ports.conf.erb"
  variables :apache_listen_ports => node['apache']['listen_ports'].map { |p| p.to_i }.uniq
  notifies :restart, "service[apache2]"
end

include_recipe "apache2::mod_deflate"
node['apache']['default_modules'].each do |mod|
  module_recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
  include_recipe "apache2::#{module_recipe_name}"
end

# Create and enable default site
template "#{node['apache']['dir']}/sites-available/default" do
  source "default-site.erb"
  notifies :restart, "service[apache2]"
end

apache_site "default" do
  enable node['apache']['default_site_enabled']
end

service "apache2" do
  service_name "Apache2.2"
  action [:enable, :start]
end
