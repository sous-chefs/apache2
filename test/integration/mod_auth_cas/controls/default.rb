include_controls 'apache2-integration-tests' do
  skip_control 'welcome-page'
end

control 'auth_cas module enabled & running' do
  impact 1
  desc 'auth_cas module should be enabled with config'

  describe command('apachectl -M') do
    its('stdout') { should match(/auth_cas/) }
  end
end
