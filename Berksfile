source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'apt', '~> 2.9.2'
  cookbook 'yum', '~> 3.8.2'
  cookbook 'zypper', '~> 0.2.1'
  cookbook 'pacman', '~> 1.1.1'
  cookbook 'fqdn', :git => 'https://github.com/drpebcak/fqdn-cookbook.git'
end

cookbook 'apache2_test', :path => 'test/fixtures/cookbooks/apache2_test'
