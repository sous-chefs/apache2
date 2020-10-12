include_controls 'apache2-integration-tests' do
  skip_control 'welcome-page'
end

control 'WSGI module enabled & running' do
  impact 1
  desc 'wsgi module should be enabled with config'

  describe command('apachectl -M') do
    its('stdout') { should match(/wsgi_module/) }
  end

  describe http('localhost') do
    its('status') { should eq 200 }
    its('body') { should match /Hello World!/ }
  end
end
