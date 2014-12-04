source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'iptables', '~> 0.13.2'
  cookbook 'logrotate', '~> 1.6.0'
  cookbook 'apt', '~> 2.4'
  cookbook 'yum', '~> 3.2'
  cookbook 'zypper', '~> 0.1.0'
  cookbook 'pacman', '~> 1.1.1'
  cookbook 'fqdn', :git => 'https://github.com/drpebcak/fqdn-cookbook.git'
end

cookbook 'apache2_test', :path => 'test/fixtures/cookbooks/apache2_test'
