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

property :index_options, Array,
         default: %w(FancyIndexing VersionSort HTMLTable NameWidth=* DescriptionWidth=* Charset=UTF-8),
         description: ''

property :readme_name, String,
         default: 'README.html',
         description: ''

property :header_name, String,
         default: 'HEADER.html',
         description: ''

property :index_ignore, String,
         default: '.??* *~ *# RCS CVS *,v *,t',
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'autoindex.conf') do
    source 'mods/autoindex.conf.erb'
    cookbook 'apache2'
    variables(
      index_options: new_resource.index_options,
      readme_name: new_resource.readme_name,
      header_name: new_resource.header_name,
      index_ignore: new_resource.index_ignore
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
