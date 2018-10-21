#
# Cookbook:: apache2
# Definition:: apache_module
#
# Copyright:: 2008-2017, Chef Software, Inc.
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

property :mod_name, String,
         default: lazy { "mod_#{name}.so" },
         description: 'The full name of the file'
property :path, String,
         default: lazy { "#{libexec_dir}/#{mod_name}" },
         description: ''
property :identifier, String,
         default: lazy { "#{name}_module" },
         description: 'String to identify the module for the `LoadModule` directive'
property :conf, [true, false],
         default: false,
         description: 'Set to true if the module has a config file, which will use `apache_mod` for the file.'
property :apache_service_notification, Symbol,
         equal_to: %i( reload restart ),
         default: :reload,
         description: 'Service notifcation for apache2 service, accepts reload or restart.'

action :enable do
  apache2_mod new_resource.name if new_resource.conf

  file ::File.join(apache_dir, 'mods-available', "#{new_resource.name}.load") do
    content "LoadModule #{new_resource.identifier} #{new_resource.path}\n"
    mode '0644'
  end

  execute "a2enmod #{new_resource.name}" do
    command "/usr/sbin/a2enmod #{new_resource.name}"
    notifies new_resource.apache_service_notification, 'service[apache2]', :delayed
    not_if { mod_enabled?(new_resource) }
  end
end

action :disable do
  execute "a2dismod #{new_resource.name}" do
    command "/usr/sbin/a2dismod #{new_resource.name}"
    notifies new_resource.apache_service_notification, 'service[apache2]', :delayed
    only_if { mod_enabled?(new_resource) }
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
