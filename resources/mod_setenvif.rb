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
property :browser_match, Array,
         default: [
           '"Mozilla/2" nokeepalive',
           '"MSIE 4\.0b2;" nokeepalive downgrade-1.0 force-response-1.0',
           '"RealPlayer 4\.0" force-response-1.0',
           '"Java/1\.0" force-response-1.0',
           '"JDK/1\.0" force-response-1.0',
           '"Microsoft Data Access Internet Publishing Provider" redirect-carefully',
           '"MS FrontPage" redirect-carefully',
           '"^WebDrive" redirect-carefully',
           '"^WebDAVFS/1.[012]" redirect-carefully',
           '"^gnome-vfs/1.0" redirect-carefully',
           '"^gvfs/1" redirect-carefully',
           '"^XML Spy" redirect-carefully',
           '"^Dreamweaver-WebDAV-SCM1" redirect-carefully',
           '"Konqueror/4" redirect-carefully',
         ],
         description: ''
property :browser_match_nocase, Array,
         default: [],
         description: ''
property :set_env_if_no_case, Array,
         default: [],
         description: ''

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mod_setenvif.conf') do
    source 'mods/setenvif.conf.erb'
    cookbook 'apache2'
    variables(
      browser_match: new_resource.browser_match,
      browser_matches_no_case: new_resource.browser_match_nocase,
      set_env_if_no_cases: new_resource.set_env_if_no_case
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
