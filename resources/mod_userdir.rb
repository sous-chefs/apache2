#
# Cookbook:: apache2
# Resource:: apache2_mod_userdir
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

property :public_html_dir, String,
         default: '/home/*/public_html',
         description: ''
property :options, String,
         default: 'MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec',
         description: ''
property :allow_override, String,
         default: 'FileInfo AuthConfig Limit Indexes',
         description: 'For full description see https://httpd.apache.org/docs/2.4/mod/core.html#allowoverride'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_userdir.conf') do
    source 'mods/userdir.conf.erb'
    cookbook 'apache2'
    variables(
      public_html_dir: new_resource.public_html_dir,
      allow_override: new_resource.allow_override,
      options: new_resource.options
    )
  end
end
