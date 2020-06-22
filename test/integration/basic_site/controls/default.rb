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
