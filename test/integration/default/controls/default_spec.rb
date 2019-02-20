control 'service' do
  impact 1
  desc 'Apache2 service is running'

  case os[:family]
  when 'debian', 'suse'
    describe service('apache2') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  when 'freebsd'
    describe service('apache24') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  else
    describe service('httpd') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end

control 'welcome-page' do
  impact 1
  desc 'Apache2 Welcome Pages Displayed'

  case os[:family]
  when 'debian', 'suse'
    describe http('localhost') do
      its('status') { should eq 200 }
      its('body') { should cmp /This is the default welcome page/ }
    end
  when 'freebsd'
    describe http('localhost') do
      its('status') { should eq 200 }
      its('body') { should_not cmp /Forbidden/ }
    end
  else
    describe http('localhost') do
      its('status') { should eq 403 }
      its('body') { should_not cmp /Forbidden/ }
      its('body') { should cmp /powered by CentOS/ }
    end
  end
end

#  Disable until all platforms are pukka
# include_controls 'dev-sec/apache-baseline' do
#   skip_control 'apache-05' # We don't have hardening.conf
#   skip_control 'apache-10' # We don't have hardening.conf
#   skip_control 'apache-13' # We don't enable SSL by defauly (yet)
# end
