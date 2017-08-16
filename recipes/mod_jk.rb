#
# Cookbook:: apache2
# Recipe:: jk
#
# Copyright:: 2013, Mike Babineau <michael.babineau@gmail.com>
# Copyright:: 2013, Chef Software, Inc.
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

if platform_family?('rhel', 'amazon', 'fedora', 'centos')
  package %W(gcc gcc-c++ #{node['apache']['devel_package']} apr apr-devel apr-util apr-util-devel make autoconf libtool)

  version = node['apache']['mod_jk']['version']
  configure_flags = node['apache']['mod_jk']['configure_flags']

  remote_file "#{Chef::Config[:file_cache_path]}/tomcat-connectors-#{version}-src.tar.gz" do
    source node['apache']['mod_jk']['source_url']
    checksum node['apache']['mod_jk']['checksum']
    mode '0644'
    action :create_if_missing
  end

  bash 'untar mod_jk' do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -zxf tomcat-connectors-#{version}-src.tar.gz
    EOH
    creates "#{Chef::Config['file_cache_path']}/tomcat-connectors-#{version}-src/native/common/jk_connect.h"
  end

  bash 'compile mod_jk' do
    cwd "#{Chef::Config[:file_cache_path]}/tomcat-connectors-#{version}-src/native"
    environment 'PKG_CONFIG_PATH' => node['apache']['mod_jk']['pkg_dir']
    code <<-EOH
    ./configure #{configure_flags.join(' ')}
    make
    EOH
    creates "#{Chef::Config['file_cache_path']}/tomcat-connectors-#{version}-src/native/apache-2.0/.libs/mod_jk.so"
    notifies :run, 'bash[install mod_jk]', :immediately
    not_if "test -f #{Chef::Config['file_cache_path']}/tomcat-connectors-#{version}-src/native/apache-2.0/.libs/mod_jk.so"
  end

  bash 'install mod_jk' do
    user 'root'
    cwd "#{Chef::Config['file_cache_path']}/tomcat-connectors-#{version}-src/native"
    environment 'PKG_CONFIG_PATH' => node['apache']['mod_jk']['pkg_dir']
    code <<-EOH
    make install
    EOH
    creates "#{node['apache']['libexec_dir']}/mod_jk.so"
    notifies :restart, 'service[apache2]'
    not_if "test -f #{node['apache']['libexec_dir']}/mod_jk.so"
  end

  template "#{node['apache']['dir']}/mods-available/jk.load" do
    source 'mods/jk.load.erb'
    owner 'root'
    group node['apache']['root_group']
    mode '0644'
  end

  apache_module 'jk' do
    conf true
  end

else
  package 'libapache2-mod-jk'
  apache_module 'jk'
end
