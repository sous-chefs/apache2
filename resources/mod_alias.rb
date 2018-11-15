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

property :options, Array,
         default: %w(Indexes MultiViews SymLinksIfOwnerMatch),
         description: ''
property :icondir, String,
         default: lazy { icon_dir },
         description: 'The icon directory'
property :allow_override, Array,
         default: %w(None),
         description: 'For full description see https://httpd.apache.org/docs/2.4/mod/core.html#allowoverride'
property :require, String,
         default: 'all granted',
         description: 'For full description see https://httpd.apache.org/docs/2.4/mod/mod_authz_core.html#require'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'alias.conf') do
    source 'mods/alias.conf.erb'
    cookbook 'apache2'
    variables(
      icondir: new_resource.icondir,
      options: new_resource.options,
      allow_override: new_resource.allow_override,
      require: new_resource.require
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
