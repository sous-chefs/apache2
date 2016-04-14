name 'apache2'
maintainer 'Sander van Zoest'
maintainer_email 'sander+cookbooks@vanzoest.com'
issues_url 'https://github.com/svanzoest-cookbooks/apache2/issues' if respond_to?(:issues_url)
source_url 'https://github.com/svanzoest-cookbooks/apache2/' if respond_to?(:source_url)
license 'Apache 2.0'
description 'Installs and configures all aspects of apache2 using Debian style symlinks with helper definitions'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.2.2'

supports 'debian'
supports 'ubuntu'
supports 'redhat'
supports 'centos'
supports 'fedora'
supports 'amazon'
supports 'scientific'
supports 'freebsd'
supports 'suse'
supports 'opensuse'
supports 'arch'
