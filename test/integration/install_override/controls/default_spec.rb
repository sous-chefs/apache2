include_controls
control 'install-override' do
  impact 1
  desc 'Apache2 override install settings'

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

  case os[:family]
  when 'debian'
    describe file("#{apache_dir}/envvars") do
      it { should exist }
      its('content') { should cmp /FOO=bar/ }
      its('content') { should cmp Regexp.excape('PIDFILE=/var/run/apache2/apache2.pid/') }
    end
  when 'redhat', 'suse'
    describe file("/etc/sysconfig/#{apache_platform_service_name}") do
      it { should exist }
      its('content') { should cmp /FOO=bar/ }
      its('content') { should cmp Regexp.excape('PIDFILE=/var/run/httpd/httpd.pid') }
    end
  end
end

#  Disable until all platforms are pukka
# include_controls 'dev-sec/apache-baseline' do
#   skip_control 'apache-05' # We don't have hardening.conf
#   skip_control 'apache-10' # We don't have hardening.conf
#   skip_control 'apache-13' # We don't enable SSL by default (yet)
# end
