source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'apt', '~> 5.0.0'
  cookbook 'fqdn', :git => 'https://github.com/drpebcak/fqdn-cookbook.git'
  cookbook 'pacman', '~> 1.1.1'
  cookbook 'yum', '~> 4.1.0'
  cookbook 'zypper', '~> 0.3.0'
end

cookbook 'apache2_test', :path => 'test/fixtures/cookbooks/apache2_test'
