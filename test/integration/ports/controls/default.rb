include_controls 'apache2-integration-tests' do
  skip_control 'welcome-page'
end

control 'hello-world' do
  impact 1
  desc 'Hello World page should be visible on port 8080'

  describe http('https://127.0.0.1:8080', ssl_verify: false) do
    its('status') { should eq 200 }
    its('body') { should cmp /Hello World/ }
  end
end
