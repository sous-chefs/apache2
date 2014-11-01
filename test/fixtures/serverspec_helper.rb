require 'serverspec'
require 'json'


# centos-59 doesn't have /sbin in the default path,
# so we must ensure it's on serverspec's path
set :path, '/sbin:/usr/local/sbin:$PATH'
set :backend, :exec

# http://serverspec.org/advanced_tips.html
# os[:family]  # RedHat, Ubuntu, Debian and so on
# os[:release] # OS release version (cleaned up in v2)
# os[:arch]
osmapping = {
  'redhat' => {
    :platform_family => 'rhel',
    :platform => 'centos',
    :platform_version => '6.5'
  },
  'redhat7' => {
    :platform_family => 'rhel',
    :platform => 'centos',
    :platform_version => '7.0'
  },
  'fedora' => {
    :platform_family => 'rhel',
    :platform => 'fedora',
    :platform_version => '20'
  },
  'ubuntu' => {
    :platform_family => 'debian',
    :platform => 'ubuntu',
    :platform_version => '12.04'
  },
  'debian' => {
    :platform_family => 'debian',
    :platform => 'debian',
    :platform_version => '7.4'
  },
  'freebsd' => {
    :platform_family => 'freebsd',
    :platform => 'freebsd',
    :platform_version => '9.2'
  },
  'freebsd10' => {
    :platform_family => 'freebsd',
    :platform => 'freebsd',
    :platform_version => '10.0'
  }
}

def ohai_platform(os, osmapping)
  puts "serverspec os detected as: #{os[:family]} #{os[:release]} [#{os[:arch]}]"
  ohaistub = {}
  ohaistub[:platform_family] = osmapping[os[:family]][:platform_family]
  ohaistub[:platform] = osmapping[os[:family]][:platform]
  if os[:release]
    ohaistub[:platform_version] = os[:release]
  else
    ohaistub[:platform_version] = osmapping[os[:family]][:platform_version]
  end
  ohaistub
end

def load_nodestub(ohai)
  puts "loading #{ohai[:platform]}/#{ohai[:platform_version]}"
  JSON.parse(IO.read("#{ENV['BUSSER_ROOT']}/../kitchen/data/platforms/#{ohai[:platform]}/#{ohai[:platform_version]}.json"), :symbolize_names => true)
end

RSpec.configure do |config|
  set_property load_nodestub(ohai_platform(os, osmapping))
end
