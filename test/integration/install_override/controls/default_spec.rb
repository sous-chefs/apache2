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
  when 'debian'
    describe http('localhost') do
      its('status') { should eq 200 }
      its('body') { should cmp /This is the default welcome page/ }
    end
  when 'freebsd'
    describe http('localhost') do
      its('status') { should eq 200 }
      its('body') { should_not cmp /Forbidden/ }
    end
  when 'suse'
    describe http('localhost') do
      its('status') { should eq 403 }
      its('body') { should cmp /Forbidden/ }
      its('body') { should cmp /Apache.* Server/ }
    end
  else
    describe http('localhost') do
      its('status') { should eq 403 }
      its('body') { should_not cmp /Forbidden/ }
      its('body') { should cmp /powered by (the Apache|CentOS)/ }
    end
  end
end

control 'install-override' do
  impact 1
  desc 'Apache2 override install settings'

  apache_dir = case os[:family]
               when 'debian', 'suse'
                 '/etc/apache2'
               else
                 '/etc/httpd'
               end

  describe file("#{apache_dir}/conf-enabled/security.conf") do
    it { should exist }
    its('content') { should cmp /ServerTokens Minimal/ }
    its('content') { should cmp /ServerSignature On/ }
    its('content') { should cmp /TraceEnable On/ }
  end

  describe file("#{apache_dir}/conf-enabled/charset.conf") do
    it { should exist }
    its('content') { should cmp /AddDefaultCharset utf-8/ }
  end
end

#  Disable until all platforms are pukka
# include_controls 'dev-sec/apache-baseline' do
#   skip_control 'apache-05' # We don't have hardening.conf
#   skip_control 'apache-10' # We don't have hardening.conf
#   skip_control 'apache-13' # We don't enable SSL by defauly (yet)
# end
