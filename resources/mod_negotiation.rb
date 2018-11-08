#
# Cookbook:: apache2
# Resource:: apache2_mod_negotiation
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
property :language_priority, Array,
         default: %w( en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv tr zh-CN zh-TW),
         description: ''

property :force_language_priority, String,
         default: 'Prefer Fallback',
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_negotiation.conf') do
    source 'mods/negotiation.conf.erb'
    cookbook 'apache2'
    variables(
      language_priority: new_resource.language_priority.join(' '),
      force_language_priority: new_resource.force_language_priority
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
