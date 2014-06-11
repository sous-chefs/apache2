require 'serverspec'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS

RSpec.configure do |config|
  config.before(:all) do
    # centos-59 doesn't have /sbin in the default path,
    # so we must ensure it's on serverspec's path
    config.path = '/sbin'
  end
end
