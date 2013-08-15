#
# Cookbook Name:: apache2
# Recipe:: php5
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

case node['platform_family']
when "debian"

  package "libapache2-mod-php5"

when "arch"

  package "php-apache" do
    notifies :run, "execute[generate-module-list]", :immediately
  end

when "rhel"

  package "which"
  package "php package" do
    if node['platform_version'].to_f < 6.0
      package_name "php53"
    else
      package_name "php"
    end
    notifies :run, "execute[generate-module-list]", :immediately
    not_if "which php"
  end

when "fedora"

  package "php package" do
    package_name "php"
    notifies :run, "execute[generate-module-list]", :immediately
    not_if "which php"
  end

when "freebsd"

  freebsd_port_options "php5" do
    options "APACHE" => true
    action :create
  end

  package "php package" do
    package_name "php5"
    source "ports"
    notifies :run, "execute[generate-module-list]", :immediately
  end

when  "windows"
  config = node["apache"]["mod_php5"]["windows"]
  dir = config["source"].split("/").last[/(.*)\.zip/] && $1
  temp_path = "#{Chef::Config["file_cache_path"]}/#{dir}"

  remote_file "#{temp_path}.zip" do
    source config["source"]
    checksum config["checksum"]
    notifies :unzip, "windows_zipfile[#{temp_path}]", :immediately
    notifies :stop, "service[apache2]", :immediately
    notifies :run, "execute[Copy PHP Module]", :immediately
    notifies :restart, "service[apache2]"
  end

  windows_zipfile temp_path do
    action :nothing
    source "#{temp_path}.zip"
  end

  filename = config["dll"].split("/").last
  source = "#{temp_path}/#{config["dll"]}".gsub("/", "\\")
  dest = "#{node["apache"]["lib_dir"]}/#{filename}".gsub("/","\\")

  execute "Copy PHP Module" do
    command "copy #{source} #{dest}"
    action :nothing
    not_if { File.exists?(dest) }
  end

end

file "#{node['apache']['dir']}/conf.d/php.conf" do
  action :delete
  backup false
end

apache_module "php5" do
  case node['platform_family']
  when "rhel", "fedora", "freebsd"
    conf true
    filename "libphp5.so"
  when "windows"
    conf true
    filename node["apache"]["mod_php5"]["windows"]["dll"].split("/").last
  end
end
