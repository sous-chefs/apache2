include_controls 'apache2-default' do
  skip_control 'welcome-page'
end

httpd_command =
  case os.family
  when 'fedora', 'amazon'
    'httpd -M'
  when 'redhat'
    os.release.to_i >= 9 ? 'httpd -M' : 'apachectl -M'
  else
    'apachectl -M'
  end

control 'auth_cas module enabled & running' do
  impact 1
  desc 'auth_cas module should be enabled with config'

  describe command httpd_command do
    its('stdout') { should match(/auth_cas/) }
  end
end
