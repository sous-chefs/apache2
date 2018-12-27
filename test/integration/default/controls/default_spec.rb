#
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
control 'package-installed' do
  impact 0
  desc 'Apache2 service is running'

  case os[:family]
  when 'debian', 'suse'
    describe service('apache2') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end

    describe http('localhost') do
      its('status') { should eq 200 }
      its('body') { should cmp /This is the default welcome page/ }
    end

  when 'freebsd'
    describe service('apache24') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end

    describe http('localhost') do
      its('status') { should eq 200 }
      its('body') { should_not cmp /Forbidden/ }
    end

  else
    describe service('httpd') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end

    describe http('localhost') do
      its('status') { should eq 403 }
      its('body') { should_not cmp /Forbidden/ }
      its('body') { should cmp 'CentOS' }
    end
  end
end

#  Disable until all platforms are pukka
# include_controls 'dev-sec/apache-baseline' do
#   skip_control 'apache-05' # We don't have hardening.conf
#   skip_control 'apache-10' # We don't have hardening.conf
#   skip_control 'apache-13' # We don't enable SSL by defauly (yet)
# end
