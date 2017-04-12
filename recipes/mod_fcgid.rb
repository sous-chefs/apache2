#
# Cookbook:: apache2
# Recipe:: mod_fcgid
#
# Copyright:: 2008-2013, Chef Software, Inc.
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

if platform_family?('debian')
  package 'libapache2-mod-fcgid'
elsif platform_family?('rhel', 'fedora', 'amazon')
  package 'mod_fcgid' do
    notifies :run, 'execute[generate-module-list]', :immediately
  end

  file "#{node['apache']['dir']}/conf.d/fcgid.conf" do
    content '# conf is under mods-available/fcgid.conf - apache2 cookbook\n'
    only_if { ::Dir.exist?("#{node['apache']['dir']}/conf.d") }
  end

  # CentOS 7 (and recent Fedoras) have Apache 2.4, where FCGI socket path
  # and shared memory path is managed adequately without further involvment
  # neccessary (subdirectory is created under /var/run/httpd).
  #
  # However, when the path is specified manually, that subdirectory is NOT
  # created automatically if it doesn't already exist and Apache fails to
  # start. Since in recent RHEL systems /var/run is on tmpfs, end result is
  # that chef-created subdirectory disappears on shutdown, and Apache fails
  # to start after server reboot. Best to leave out these two settings
  # unset then.
  if (node['platform_family'] == 'rhel') && (node['platform_version'].to_i == 6)
    directory '/var/run/httpd/mod_fcgid' do
      owner node['apache']['user']
      group node['apache']['group']
      recursive true
    end
  end

elsif platform_family?('suse')
  apache_lib_path = node['apache']['lib_dir']

  package node['apache']['devel_package']

  bash 'install-fcgid' do
    code <<-EOH
(cd #{Chef::Config['file_cache_path']}; wget http://superb-east.dl.sourceforge.net/sourceforge/mod-fcgid/mod_fcgid.2.2.tgz)
(cd #{Chef::Config['file_cache_path']}; tar zxvf mod_fcgid.2.2.tgz)
(cd #{Chef::Config['file_cache_path']}; perl -pi -e 's!/usr/local/apache2!#{apache_lib_path}!g' ./mod_fcgid.2.2/Makefile)
(cd #{Chef::Config['file_cache_path']}/mod_fcgid.2.2; make install)
EOH
  end
end

apache_module 'fcgid' do
  conf true
end
