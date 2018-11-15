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
property :directory_index, Array,
         default: %w(
           index.html
           index.cgi
           index.pl
           index.php
           index.xhtml
           index.htm
         ),
         description: 'Array of directory indexes'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'dir.conf') do
    source 'mods/dir.conf.erb'
    cookbook 'apache2'
    variables(
      directory_index: new_resource.directory_index
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
