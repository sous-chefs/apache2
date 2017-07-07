
def supported_platforms
  platforms = {
    'amazon' => ['2016.09', '2017.03'],
    'ubuntu' => ['14.04', '16.04'],
    'debian' => ['8.8'],
    'fedora' => %w(25),
    'redhat' => ['7.2'],
    'centos' => ['7.3.1611'],
    'freebsd' => ['10.3'],
    'opensuse' => ['42.2'],
  }
end
