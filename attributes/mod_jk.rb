#
# Cookbook:: apache2
# Attributes:: mod_jk
#
# Copyright:: 2013, Chef Software, Inc.
# Copyright:: 2014-2016, Alexander van Zoest
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

# mod_jk
default['apache']['mod_jk']['version']    = '1.2.42'
default['apache']['mod_jk']['source_url'] = "http://www-us.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-#{node['apache']['mod_jk']['version']}-src.tar.gz"
default['apache']['mod_jk']['checksum']  = 'ea119f234c716649d4e7d4abd428852185b6b23a9205655e45554b88f01f3e31'

default['apache']['mod_jk']['pkg_dir'] = node['kernel']['machine'] =~ /^i[36]86$/ ? '/usr/lib/pkgconfig' : '/usr/lib64/pkgconfig'
default['apache']['mod_jk']['configure_flags'] = [
  '--with-apxs=/usr/bin/apxs'
]
