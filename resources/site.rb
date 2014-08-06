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
actions :create, :delete
default_action :create

attribute :conf, kind_of: String
attribute :enable, kind_of: TrueClass, default: false

def initialize(*args)
  super
  @action = :create
end
