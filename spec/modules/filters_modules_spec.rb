require 'spec_helper'

# not supported modules: charset_lite ext_filter reqtimeout substitute
filters_modules_without_config = %w(filter)
filters_modules_with_config = %w(include deflate)
filters_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
filters_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end
