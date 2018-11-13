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

property :cache_root, String,
         default: lazy { default_cache_root },
         description: ''

property :cache_dir_levels, String,
         default: '2',
         description: 'https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html#cachedirlevels'

property :cache_dir_length, String,
         default: '2',
         description: 'https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html#cachedirlength'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_cache_disk.conf') do
    source 'mods/cache_disk.conf.erb'
    cookbook 'apache2'
    variables(
      cache_root: new_resource.cache_root,
      cache_dir_levels: new_resource.cache_dir_levels,
      cache_dir_length: new_resource.cache_dir_length
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
