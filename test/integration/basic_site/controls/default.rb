include_controls 'apache2-integration-tests' do
  skip_control 'welcome-page'
end

control 'hello-world' do
  impact 1
  desc 'Hello World page should be visible'

  describe http('localhost') do
    its('status') { should eq 200 }
    its('body') { should cmp /Hello World/ }
  end
end

control 'disabled-site' do
  impact 1
  desc 'Site config should be installed, but disabled'

  apache_dir = case os[:family]
               when 'debian', 'suse'
                 '/etc/apache2'
               else
                 '/etc/httpd'
               end

  describe file("#{apache_dir}/sites-available/disabled_site.conf") do
    it { should exist }
  end

  describe file("#{apache_dir}/sites-enabled/disabled_site.conf") do
    it { should_not exist }
  end
end
