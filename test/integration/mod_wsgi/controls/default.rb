include_controls 'apache2-default'

httpd_command =
  case os.family
  when 'fedora'
    'httpd -M'
  when 'redhat'
    os.release.to_i >= 9 ? 'httpd -M' : 'apachectl -M'
  else
    'apachectl -M'
  end

control 'WSGI module enabled & running' do
  impact 1
  desc 'wsgi module should be enabled with config'

  describe command httpd_command do
    its('stdout') { should match(/wsgi_module/) }
  end

  describe http('localhost') do
    its('status') { should eq 200 }
    its('body') { should match /Hello World!/ }
  end
end
