require 'spec_helper'

# not supported modules: imagemap speling vhost_alias
mappers_modules_without_config = %w(rewrite)
mappers_modules_with_config = %w(actions alias dir userdir negotiation)
mappers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
mappers_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end
