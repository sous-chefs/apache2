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
class Chef::Resource::Execute
  def format_cmd(command)
    command unless platform_family?('windows')
    "bash #{command}".gsub('/', '\\')
  end
end


install_dir = File.expand_path(node['apache']['dir']).gsub('/', '\\')
windows_package "Apache HTTP Server 2.2.22" do
  source node['apache']['windows']['source']
  installer_type :msi
  options %W[
          /quiet
          INSTALLDIR="#{install_dir}"
          ALLUSERS=1
          SERVERADMIN=foo@example.com
          SERVERDOMAIN=example.com
          SERVERNAME=bar
  ].join(" ")
end

# Needs more info
service "apache2" do
  service_name "Apache2.2"
  action :enable
end

# Ensure that all of the directories exist and that Apache can touch them
%w{ dir log_dir conf_dir bin_dir cache_dir }.each do |dir|
  directory node['apache'][dir] do
    #mode "00755"
    #owner node['apache']['user']
    #group node['apache']['group']
  end
end

# Removes extraneous folders
%w{extra original}.each do |d|
  directory "#{node['apache']['conf_dir']}/#{d}" do
    action :delete
    recursive true
  end
end

# Allow Debian style module and site management
%w{ sites-available sites-enabled mods-available mods-enabled }.each do |dir|
  directory "#{node['apache']['dir']}/#{dir}" do
    #mode "00755"
    #owner "root"
    #group node['apache']['root_group']
  end
end

%w{a2ensite a2dissite a2enmod a2dismod}.each do |modscript|
  template "#{node['apache']['bin_dir']}/#{modscript}" do
    source "#{modscript}.erb"
    #mode "00700"
    #owner "root"
    #group node['apache']['root_group']
  end
end

# Creates module.load files
# package "perl"
cookbook_file "#{node['apache']['bin_dir']}/apache2_module_conf_generate.pl" do
  source "apache2_module_conf_generate.pl"
  #mode "00755"
  #owner "root"
  #group node['apache']['root_group']
end

execute "generate-module-list" do
  command "#{node['apache']['bin_dir']}/apache2_module_conf_generate.pl #{node['apache']['lib_dir']} #{node['apache']['dir']}/mods-available"
  action :nothing
end


template "apache2.conf" do
  path node['apache']['conf']
  source "apache2.conf.erb"
  #owner "root"
  #group node['apache']['root_group']
  #mode "00644"
  notifies :restart, "service[apache2]"
end

[
    %w{ apache2-conf-security security security.erb },
    %w{ apache2-conf-charset charset charset.erb }
].each do |name, file, src|
  template name do
    path "#{node['apache']['conf_dir']}/#{file}"
    source src
    #owner "root"
    #group node['apache']['root_group']
    #mode "00644"
    notifies :restart, "service[apache2]"
  end
end

template "#{node['apache']['dir']}/ports.conf" do
  source "ports.conf.erb"
  #owner "root"
  #group node['apache']['root_group']
  #mode "00644"
  variables :apache_listen_ports => node['apache']['listen_ports'].map { |p| p.to_i }.uniq
  notifies :restart, "service[apache2]"
end

# include_recipe "apache2::mod_deflate"
node['apache']['default_modules'].each do |mod|
  module_recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
  include_recipe "apache2::#{module_recipe_name}"
end

# Create and enable default site
template "#{node['apache']['dir']}/sites-available/default" do
  source "default-site.erb"
  #owner "root"
  #group node['apache']['root_group']
  #mode 00644
  notifies :restart, "service[apache2]"
end

apache_site "default" do
  enable node['apache']['default_site_enabled']
end

service "apache2" do
  action [:enable, :start]
end