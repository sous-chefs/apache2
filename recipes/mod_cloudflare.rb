#
# Cookbook Name:: apache2
# Recipe:: mod_cloudflare
#
# Copyright 2008-2013, Chef Software, Inc.
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

case node['platform_family']
when 'debian'
  apt_repository 'cloudflare' do
    uri 'http://pkg.cloudflare.com'
    distribution node['lsb']['codename']
    components ['main']
    key 'http://pkg.cloudflare.com/pubkey.gpg'
    action :add
  end
  package 'libapache2-mod-cloudflare'
  apache_module 'cloudflare'
when 'rhel', 'fedora'
  yum_repository 'cloudflare' do
    description 'CloudFlare Packages'
    baseurl 'http://pkg.cloudflare.com/dists/$releasever/main/binary-$basearch'
    gpgkey 'http://pkg.cloudflare.com/pubkey.gpg'
    action :create
  end
  package 'mod_cloudflare'
  apache_module 'cloudflare'
else
  Chef::Log.warn "apache::mod_cloudflare does not support #{node['platform_family']}; mod_cloudflare is not being installed"
end
