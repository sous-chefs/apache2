require 'spec_helper'

describe 'apache2::mod_auth_cas' do
  it_should_behave_like 'an apache2 module', 'auth_cas', true, supported_platforms
end
