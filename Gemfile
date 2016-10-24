source 'https://rubygems.org'

# resolve nokogiri updates for chefdk, although it may force chefdk now
# https://github.com/chef/chef-dk/issues/278#issuecomment-89251860
ENV['PKG_CONFIG_PATH'] = '/opt/chefdk/embedded/lib/pkgconfig'

gem 'berkshelf', '~> 5.1', '>= 5.1.0'

group :unit do
  gem 'foodcritic',       '~> 8.1', '>= 8.1.0'
  gem 'rubocop',          '~> 0.44', '>= 0.44.1'
  gem 'chefspec',         '~> 5.2', '>= 5.2.0'
end

group :integration do
  gem 'test-kitchen', '~> 1.13.2'
  gem 'kitchen-vagrant', '~> 0.20', :require => false
  gem 'kitchen-digitalocean', :require => false
  gem 'kitchen-ec2', :require => false
  gem 'kitchen-docker', :require => false
end

group :development do
  gem 'guard', '~> 2.14'
  gem 'guard-rubocop',    '~> 1.2'
  # gem 'guard-foodcritic', '~> 2.1'
  gem 'guard-kitchen',    '~> 0.0'
  gem 'guard-rspec',      '~> 4.7.3'
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'terminal-notifier-guard', require: false
  gem 'psych', '~> 2.1.1'
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /mswin|mingw|cygwin/i
    gem 'wdm', '>= 0.1.1'
    gem 'win32console'
  end
end
