require 'serverspec'
require 'json'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS
include SpecInfra::Helper::Properties

def ohai_platform(os)
  # http://serverspec.org/advanced_tips.html
  # os[:family]  # RedHat, Ubuntu, Debian and so on
  # os[:release] # OS release version (cleaned up in v2)
  # os[:arch]
  ohai = {}
  case os[:family]
  when 'RedHat'
    ohai[:platform] = 'centos'
    ohai[:platform_version] = '6.5'
  when 'RedHat7', 'SuSE', 'OpenSUSE'
    ohai[:platform] = 'centos'
    # ohai[:platform_version] = '7.0'
    ohai[:platform_version] = os[:release]
  when 'Fedora'
    ohai[:platform] = 'fedora'
    ohai[:platform_version] = '20'
  when 'Ubuntu'
    ohai[:platform] = 'ubuntu'
    ohai[:platform_version]  = '12.04'
  when 'Debian'
    ohai[:platform] = 'debian'
    ohai[:platform_version]  = '7.4'
  when 'Arch'
    ohai[:platform] = 'arch'
  when 'FreeBSD'
    ohai[:platform] = 'freebsd'
    ohai[:platform_version]  = '9.2'
  when 'FreeBSD10'
    ohai[:platform] = 'freebsd'
    ohai[:platform_version]  = '10.0'
  # when 'Solaris', 'Solaris10', 'Solaris11'
  end
  ohai
end

def load_nodestub(ohai)
  puts "loading #{ohai[:platform]}/#{ohai[:platform_version]}"
  JSON.parse(IO.read("#{ENV['BUSSER_ROOT']}/../kitchen/data/platforms/#{ohai[:platform]}/#{ohai[:platform_version]}.json"), :symbolize_names => true)
end

RSpec.configure do |config|
  set_property load_nodestub(ohai_platform(backend.check_os))
  config.before(:all) do
    # centos-59 doesn't have /sbin in the default path,
    # so we must ensure it's on serverspec's path
    config.path = '/sbin'
  end
end
