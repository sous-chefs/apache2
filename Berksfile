source 'https://api.berkshelf.com'

metadata

group :integration do
  cookbook 'iptables'
  cookbook 'logrotate'
  cookbook 'apt', '~> 2.4'
  cookbook 'yum', '~> 3.2'
  cookbook 'freebsd', '~> 0.1.4'
  cookbook 'pacman', '~> 1.1.1'
  cookbook 'fqdn', git: 'https://github.com/drpebcak/fqdn-cookbook.git'
end

cookbook 'apache2_test', path: 'test/fixtures/cookbooks/apache2_test'
