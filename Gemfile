source 'https://rubygems.org'

# resolve nokogiri updates for chefdk, although it may force chefdk now
# https://github.com/chef/chef-dk/issues/278#issuecomment-89251860
ENV['PKG_CONFIG_PATH'] = '/opt/chefdk/embedded/lib/pkgconfig'

gem 'berkshelf', '~> 5.1', '>= 5.1.0'

group :unit do
  gem 'foodcritic', '~> 8.1', '>= 8.1.0'
  gem 'cookstyle'
  gem 'chefspec', '~> 5.3', '>= 5.3.0'
end

group :integration do
  gem 'test-kitchen', '~> 1.13.2'
  gem 'kitchen-vagrant', '~> 0.20', :require => false
  gem 'kitchen-digitalocean', :require => false
  gem 'kitchen-ec2', :require => false
  gem 'kitchen-docker', :require => false
end
