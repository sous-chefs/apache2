include_controls 'apache2-integration-tests' do
  skip_control 'welcome-page'
end

os_family = os.family

control 'auth_cas module enabled & running' do
  impact 1
  desc 'auth_cas module should be enabled with config'

  if os_family == 'fedora'
    describe command('httpd -M') do
      its('stdout') { should match(/auth_cas/) }
    end
  else
    describe command('apachectl -M') do
      its('stdout') { should match(/auth_cas/) }
    end
  end
end
