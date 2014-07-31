
def supported_platforms
  platforms = {
    'ubuntu' => ['12.04', '14.04'],
    'debian' => ['6.0.5', '7.6'],
    'fedora' => %w(18 20),
    'redhat' => ['6.5', '7.0'],
    'centos' => ['6.5', '7.0'],
    'freebsd' => ['9.2'],
    'opensuse' => ['13.1']
  }
  #  'suse' => ['11.3']
end
