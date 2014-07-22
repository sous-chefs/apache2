require 'spec_helper'

describe 'apache2::mod_dav_svn' do
  it_should_behave_like 'an apache2 module', 'dav_svn', false, supported_platforms
end
