require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4'],
}

describe 'apache2::mod_pagespeed' do
  it_should_behave_like 'an apache2 module', 'pagespeed', false, platforms
end
