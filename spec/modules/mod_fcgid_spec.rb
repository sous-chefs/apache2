require 'spec_helper'

describe 'apache2::mod_fcgid' do
  it_should_behave_like 'an apache2 module', 'fcgid', true, supported_platforms
end
