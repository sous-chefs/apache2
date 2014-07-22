require 'spec_helper'

describe 'apache2::mod_wsgi' do
  it_should_behave_like 'an apache2 module', 'wsgi', false, supported_platforms
end
