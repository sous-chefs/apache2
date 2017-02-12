#
# Cookbook:: apache2
# Recipe:: mod_php5
#
# Copyright:: 2008-2013, Chef Software, Inc.
# Copyright:: 2014, OneHealth Solutions, Inc.
# Copyright:: 2014, Viverae, Inc.
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
log 'apache2::mod_php5 is deprecated in favor of apache2::mod_php. Please adjust your cookbooks'
include_recipe 'apache2::mod_php'
