# encoding: utf-8
#
# Cookbook Name:: apache2
# Libraries:: matchers
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
if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method(:apache2_web_app)

  def create_apache2_web_app(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:apache2_web_app, :create, resource)
  end

  def delete_apache2_web_app(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:apache2_web_app, :delete, resource)
  end

end
