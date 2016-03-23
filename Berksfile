source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'apt', '~> 3.0.0'
  cookbook 'yum', '~> 3.10.0'
  cookbook 'zypper', '~> 0.2.1'
  cookbook 'pacman', '~> 1.1.1'
  cookbook 'fqdn', :git => 'https://github.com/drpebcak/fqdn-cookbook.git'
end

cookbook 'apache2_test', :path => 'test/fixtures/cookbooks/apache2_test'
