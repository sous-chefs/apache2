# encoding: utf-8
#
# Cookbook Name:: apache2
# Resources:: web_app
#
# Copyright 2012-2014, Opscode, Inc.
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
actions :create, :delete, :enable, :disable
default_action :create

attribute :group, :kind_of => String
attribute :mode, :kind_of => Fixnum, :default =>  00644
attribute :owner, :kind_of => String
attribute :source, :kind_of => String, :default => 'web_app.conf.erb'
attribute :cookbook, :kind_of => String, :default => 'apache2'
attribute :variables, :kind_of => Hash

def initialize(*args)
  super
end
