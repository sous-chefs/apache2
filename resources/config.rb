#
# Cookbook:: apache2
# Resource:: apache2_config
#
# Copyright:: 2008-2017, Chef Software, Inc.
# Copyright:: 2018, Webb Agile Solutions Ltd.
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
include Apache2::Cookbook::Helpers

property :root_group, String,
         default: lazy { default_apache_root_group },
         description: 'Group that the root user on the box runs as. Defaults to platform specific locations, see libraries/helpers.rb'
property :access_file_name, String,
         default: '.htaccess',
         description: 'String: Access filename'
property :log_dir, String,
         default: lazy { default_log_dir },
         description: 'Log directory location. Defaults to platform specific locations, see libraries/helpers.rb'
property :error_log, String,
         default: lazy { default_error_log },
         description: 'Error log location. Defaults to platform specific locations, see libraries/helpers.rb'
property :log_level, String,
         default: 'warn',
         description: 'log level for apache2'
property :apache_user, String,
         default: lazy { default_apache_user },
         description: 'Set to override the default apache2 user. Defaults to platform specific locations, see libraries/helpers.rb'
property :apache_group, String,
         default: lazy { default_apache_group },
         description: 'Set to override the default apache2 user. Defaults to platform specific locations, see libraries/helpers.rb'
property :keep_alive, String,
         equal_to: %w(On Off),
         default: 'On',
         description: 'Persistent connection feature of HTTP/1.1 provide long-lived HTTP sessions'
property :max_keep_alive_requests, Integer,
         default: 100,
         description: 'MaxKeepAliveRequests'
property :keep_alive_timeout, Integer,
         default: 5,
         description: 'KeepAliveTimeout'
property :docroot_dir, String,
         default: lazy { default_docroot_dir },
         description: 'Apache document root. Defaults to platform specific locations, see libraries/helpers.rb'

action :create do
  template 'apache2.conf' do
    if platform_family?('debian')
      path "#{apache_conf_dir}/apache2.conf"
    else
      path "#{apache_conf_dir}/httpd.conf"
    end
    action :create
    source 'apache2.conf.erb'
    cookbook 'apache2'
    owner 'root'
    group new_resource.root_group
    mode '0640'
    variables(
      apache_binary: apache_binary,
      apache_dir: apache_dir,
      lock_dir: lock_dir,
      pid_file: apache_pid_file,
      access_file_name: new_resource.access_file_name,
      log_dir: new_resource.log_dir,
      error_log: new_resource.error_log,
      log_level: new_resource.log_level,
      apache_user: new_resource.apache_user,
      apache_group: new_resource.apache_group,
      keep_alive: new_resource.keep_alive,
      max_keep_alive_requests: new_resource.max_keep_alive_requests,
      keep_alive_timeout: new_resource.keep_alive_timeout,
      docroot_dir: new_resource.docroot_dir
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
