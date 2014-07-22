require 'spec_helper'

describe 'apache2::mod_jk' do
  it_should_behave_like 'an apache2 module', 'jk', false, supported_platforms
end
