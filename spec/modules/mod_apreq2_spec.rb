require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4'],
  'fedora' => %w(18 20),
  'redhat' => ['5.9', '6.5'],
  'centos' => ['5.9', '6.5'],
  'freebsd' => ['9.2'],
  'suse' => ['11.3']
}
#  'arch' =>

describe 'apache2::mod_apreq2' do
  before do
    stub_command('test -f /usr/lib64/httpd/modules/mod_apreq2.so').and_return(true)
    stub_command('test -f /usr/lib/httpd/modules/mod_apreq2.so').and_return(true)
  end

  it_should_behave_like 'an apache2 module', 'apreq', false, platforms
end
