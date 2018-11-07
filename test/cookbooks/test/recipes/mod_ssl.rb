#
# Cookbook:: apache2_test
# Recipe:: mod_ssl
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

ssl_dir = '/home/apache2'
ssl_cert_file = "#{ssl_dir}/server.crt"
ssl_cert_key_file = "#{ssl_dir}/server.key"

apache2_install 'default'
apache2_mod 'ssl'

directory '/home/apache2' do
  extend Apache2::Cookbook::Helpers
  owner 'root'
  group apache2_root_group
  recursive true
end

execute 'create-private-key' do
  command "openssl genrsa > #{ssl_cert_key_file}"
  not_if "test -f #{ssl_cert_key_file}"
end

execute 'create-certficate' do
  command %(openssl req -new -x509 -key #{ssl_cert_key_file} -out #{ssl_cert_file} -days 1 <<EOF
US
Washington
Seattle
Chef Software, Inc

example.com
webmaster@example.com
EOF)
  not_if "test -f #{ssl_cert_file}"
end

web_app 'ssl' do
  template 'ssl.conf.erb'
  server_name 'example.com'
  document_root '/var/www'
  ssl_cert_file ssl_cert_file
  ssl_cert_key_file ssl_cert_key_file
end
