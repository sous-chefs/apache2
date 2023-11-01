include_controls 'apache2-default'

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
      its('content') { should cmp /FOO=bar/ }
    end
  when 'redhat', 'suse'
    describe file("/etc/sysconfig/#{apache_platform_service_name}") do
      its('content') { should cmp /FOO=bar/ }
    end
  end
end
