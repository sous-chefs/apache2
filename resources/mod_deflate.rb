#
# Cookbook:: apache2
# Resource:: apache2_conf
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

property :add_output_filter_by_type, Hash,
         default: {
           1 => 'DEFLATE text/html text/plain text/xml',
           2 => 'DEFLATE text/css',
           3 => 'DEFLATE application/x-javascript application/javascript application/ecmascript',
           4 => 'DEFLATE application/rss+xml',
           5 => 'DEFLATE application/xml',
           6 => 'DEFLATE application/xhtml+xml',
           7 => 'DEFLATE image/svg+xml',
           8 => 'DEFLATE application/atom_xml',
           9 => 'DEFLATE application/x-httpd-php',
           10 => 'DEFLATE application/x-httpd-fastphp',
           11 => 'DEFLATE application/x-httpd-eruby',
         },
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_deflate.conf') do
    source 'mods/deflate.conf.erb'
    cookbook 'apache2'
    variables(
      add_output_filter_by_type: new_resource.add_output_filter_by_type
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
