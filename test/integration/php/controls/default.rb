include_controls 'apache2-default' do
  skip_control 'welcome-page'
end

httpd_command =
  case os.family
  when 'fedora', 'amazon', 'suse'
    'httpd -M'
  when 'redhat'
    os.release.to_i >= 9 ? 'httpd -M' : 'apachectl -M'
  else
    'apachectl -M'
  end

control 'PHP module enabled & running' do
  impact 1
  desc 'php module should be enabled with config'

  if (os['family'] == 'redhat' && os['release'].to_i >= 9) || os['family'] == 'fedora'
    describe command httpd_command do
      its('stdout') { should match(/proxy_fcgi/) }
    end
  else
    describe command httpd_command do
      its('stdout') { should match(/php/) }
    end
  end

  case os['family']
  when 'debian', 'suse'
    describe file('/etc/apache2/mods-available/php.conf') do
      it { should exist }
      its('content') { should match %r{SetHandler application/x-httpd-php} }
    end
  when 'freebsd'
    describe file('/usr/local/etc/apache24/mods-available/php.conf') do
      it { should exist }
      its('content') { should match %r{SetHandler application/x-httpd-php} }
    end
  when 'redhat', 'fedora'
    if os['release'].to_i >= 9
      describe service('php-fpm') do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end

      describe file('/etc/httpd/conf-available/custom_php_pool.conf') do
        it { should exist }
        its('content') { should match %r{proxy:unix:/var/run/php.*-fpm.sock|fcgi://localhost} }
      end
    else
      describe file('/etc/httpd/mods-available/php.conf') do
        it { should exist }
        its('content') { should match %r{SetHandler application/x-httpd-php} }
      end
    end
  else
    describe file('/etc/httpd/mods-available/php.conf') do
      it { should exist }
      its('content') { should match %r{SetHandler application/x-httpd-php} }
    end
  end

  describe http('localhost/info.php') do
    its('status') { should eq 200 }
    its('body') { should match /PHP Version/ }
  end
end
