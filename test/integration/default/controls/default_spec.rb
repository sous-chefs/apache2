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
  when 'suse'
    describe http('localhost') do
      its('status') { should eq 403 }
      its('body') { should cmp /Forbidden/ }
      its('body') { should_not cmp /Apache.*Server/ }
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

control 'secure tuned defaults' do
  impact 1
  desc 'Apache2 defaults should render secure headers and tuned connection handling'

  apache_dir = case os[:family]
               when 'debian', 'suse'
                 '/etc/apache2'
               else
                 '/etc/httpd'
               end

  apache_conf = case os[:family]
                when 'debian'
                  "#{apache_dir}/apache2.conf"
                when 'suse'
                  "#{apache_dir}/httpd.conf"
                else
                  "#{apache_dir}/conf/httpd.conf"
                end

  describe file("#{apache_dir}/conf-enabled/security.conf") do
    it { should exist }
    its('content') { should match(/^ServerSignature Off$/) }
    its('content') { should match(/^ServerTokens Prod$/) }
    its('content') { should match(/^TraceEnable Off$/) }
  end

  describe file(apache_conf) do
    it { should exist }
    its('content') { should match(/^Timeout 60$/) }
    its('content') { should match(/^MaxKeepAliveRequests 1000$/) }
    its('content') { should match(/^KeepAliveTimeout 2$/) }
  end
end

control 'httpd tmpfiles idempotency' do
  impact 1
  desc 'On EL the log/cache dir modes match the vendor tmpfiles.d so they survive a systemd-tmpfiles --create instead of flip-flopping between converges'

  only_if('EL-only; Debian/SUSE ship no conflicting tmpfiles entry') do
    %w(redhat fedora amazon).include?(os[:family])
  end

  # Re-stamp tmpfiles the way boot or a package transaction would; with the
  # cookbook matching the vendor modes this is a no-op rather than a revert.
  describe command('systemd-tmpfiles --create httpd.conf') do
    its('exit_status') { should eq 0 }
  end

  describe file('/var/log/httpd') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0700' }
  end

  describe file('/var/cache/httpd') do
    it { should be_directory }
    it { should be_owned_by 'apache' }
    its('group') { should eq 'apache' }
    its('mode') { should cmp '0700' }
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
      its('content') { should match %r{APACHE_PID_FILE=/var/run/apache2/apache2.pid} }
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
