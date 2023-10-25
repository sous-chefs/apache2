include_controls 'apache2-default'

control 'PHP module enabled & running' do
  impact 1
  desc 'php module should be enabled with config'

  describe command('apachectl -M') do
    its('stdout') { should match(/php/) }
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
