#
# Copyright (c) 2014 OneHealth Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require_relative '../../../kitchen/data/spec_helper'

describe 'apache2::mod_ssl' do

  # it 'installs the mod_ssl package on RHEL distributions' do
  #   skip unless %w(rhel fedora).include?(node['platform_family'])
  #   describe package('mod_ssl') do
  #     it { should be_installed }
  #   end
  # end

  describe file("#{property[:apache][:dir]}/mods-available/ssl.load") do
    it { should be_file }
    it { should be_mode 644 }
    its(:content) { should match "LoadModule ssl_module #{property[:apache][:libexec_dir]}/mod_ssl.so\n" }
  end

  describe file("#{property[:apache][:dir]}/mods-enabled/ssl.load") do
    it { should be_linked_to "#{property[:apache][:dir]}/mods-available/ssl.load" }
  end

  describe command("#{property[:apache][:binary]} -M") do
    it { should return_exit_status 0 }
    it { should return_stdout(/ssl_module/) }
  end

  describe file("#{property[:apache][:dir]}/ports.conf") do
    it { should contain(/Listen 443/) }
  end

  describe file("#{property[:apache][:dir]}/mods-enabled/ssl.conf") do
    it { should be_file }
    it { should contain(/SSLCipherSuite #{Regexp.escape(property[:apache][:mod_ssl][:cipher_suite])}$/) }
  end
end
