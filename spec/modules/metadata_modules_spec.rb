require 'spec_helper'

# not supported modules: cern_meta ident mime_magic unique_id usertrack version
metadata_modules_without_config = %w(env expires headers)
metadata_modules_with_config = %w(setenvif)
metadata_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
metadata_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end
