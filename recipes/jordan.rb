#
# Cookbook Name:: apache2
# Recipe:: jordan
#
# Creates symlinks to security certificates
#
# Copyright 2008-2013, Opscode, Inc.
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

link "/etc/ssl/key.pem" do
  to "/home/vagrant/key.pem"
end

link "/etc/ssl/cert.pem" do
  to "/home/vagrant/cert.pem"
end

