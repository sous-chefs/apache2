#
# Cookbook:: apache2_test
# Recipe:: basic_web_app
#
# Copyright:: 2012, Chef Software, Inc.
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

apache2_install 'default'

directory '/var/www/basic_web_app' do
  recursive true
end

file '/var/www/index.html' do
  content 'Hello World'
end

web_app 'basic_webapp' do
  cookbook 'apache2'
  server_name 'example.com'
  server_aliases [node['fqdn']]
  docroot '/home/apache2/env'
end
