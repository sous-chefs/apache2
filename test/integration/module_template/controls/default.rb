include_controls 'apache2-integration-tests' do
  skip_control 'welcome-page'
end

control 'custom template' do
  impact 1
  desc 'mod_info.conf should be from custom template'

  case os['family']
  when 'debian', 'suse'
    describe file('/etc/apache2/mods-available/info.conf') do
      its('content') { should match(/# test cookbook custom template/) }
    end
  when 'freebsd'
    describe file('/usr/local/etc/apache24/mods-available/info.conf') do
      its('content') { should match(/# test cookbook custom template/) }
    end
  else
    describe file('/etc/httpd/mods-available/info.conf') do
      its('content') { should match(/# test cookbook custom template/) }
    end

  end
end
