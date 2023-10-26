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

  os_name = os[:name]

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
      its('body') { should cmp /Apache Server/ }
    end
  else
    describe http('localhost') do
      its('status') { should eq 403 }
      its('body') { should_not cmp /Forbidden/ }
      if os_name == 'amazon'
        its('body') { should cmp /It works!/ }
      else
        its('body') { should cmp /Powered by (CentOS|Alma|Rocky|Fedora|Apache)/ }
      end
    end
  end
end

control 'pid file' do
  apache_dir = case os[:family]
               when 'debian', 'suse'
                 '/etc/apache2'
               else
                 '/etc/httpd'
               end

  apache_platform_service_name = case os[:family]
                                 when 'debian', 'suse'
                                   'apache2'
                                 else
                                   'httpd'
                                 end

  impact 1
  desc 'PID file should be setup correctly'
  case os[:family]
  when 'debian'
    # Debian doesn't use /etc/sysconfig instead it relies on /etc/apache2/envvars
    describe file("#{apache_dir}/envvars") do
      it { should exist }
      its('content') { should cmp 'APACHE_PID_FILE=/var/run/apache2/apache2.pid' }
    end
  when 'redhat'
    describe file("/etc/sysconfig/#{apache_platform_service_name}") do
      it { should exist }
      its('content') { should match Regexp.escape('PIDFILE=/var/run/httpd/httpd.pid') }
    end
  when 'suse'
    describe file("/etc/sysconfig/#{apache_platform_service_name}") do
      it { should exist }
      its('content') { should match Regexp.escape('PIDFILE=/var/run/httpd2.pid') }
    end
  end
end
