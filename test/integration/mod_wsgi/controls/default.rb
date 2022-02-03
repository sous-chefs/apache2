include_controls 'apache2-integration-tests' do
  skip_control 'welcome-page'
end

os_family = os.family

control 'WSGI module enabled & running' do
  impact 1
  desc 'wsgi module should be enabled with config'

  if os_family == 'fedora'
    describe command('httpd -M') do
      its('stdout') { should match(/wsgi_module/) }
    end
  else
    describe command('apachectl -M') do
      its('stdout') { should match(/wsgi_module/) }
    end
  end

  describe http('localhost') do
    its('status') { should eq 200 }
    its('body') { should match /Hello World!/ }
  end
end
