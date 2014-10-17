require 'spec_helper'

# not supported modules: dav_lock
dav_modules_without_config = %w(dav)
dav_modules_with_config = %w(dav_fs)
dav_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, supported_platforms
  end
end
dav_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, supported_platforms
  end
end
