require 'spec_helper'

describe 'apache2::mod_fastcgi' do
  before do
    stub_command('test -f /usr/lib/httpd/modules/mod_auth_openid.so').and_return(true)
    stub_command('test -f /etc/httpd/mods-available/fastcgi.conf').and_return(true)
  end

  it_should_behave_like 'an apache2 module', 'fastcgi', true, supported_platforms
end
