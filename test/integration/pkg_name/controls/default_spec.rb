control 'service' do
  impact 1
  desc 'Apache2 service is running'

  describe service('httpd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'welcome-page' do
  impact 1
  desc 'Apache2 Welcome Pages Displayed'

  describe http('localhost') do
    its('status') { should eq 403 }
    its('body') { should_not cmp /Forbidden/ }
    its('body') { should cmp /It works/ }
  end
end

control 'package' do
  impact 1
  desc 'Apache2 package is installed'

  describe package 'httpd24u' do
    it { should be_installed }
  end

  describe package 'httpd24u-mod_ssl' do
    it { should be_installed }
  end
end
