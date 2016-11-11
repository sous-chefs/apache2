name 'apache2'
maintainer 'Chef Brigade'
maintainer_email 'help@chefbrigade.io'
issues_url 'https://github.com/chef-brigade/apache2/issues' if respond_to?(:issues_url)
source_url 'https://github.com/chef-brigade/apache2/' if respond_to?(:source_url)
chef_version '>= 11' if respond_to?(:chef_version)
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
supports 'opensuseleap'
supports 'arch'
