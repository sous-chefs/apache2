include_controls 'apache2-default' do
  skip_control 'welcome-page'
end

control 'hello-world' do
  impact 1
  desc 'Hello World page should be visible'

  describe http('https://127.0.0.1', ssl_verify: false) do
    its('status') { should eq 200 }
    its('body') { should cmp /Hello World/ }
  end
end
