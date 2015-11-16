source 'https://rubygems.org'

gem 'berkshelf', '~> 4.0', '>= 4.0.1'

group :unit do
  gem 'rubocop',          '~> 0.35', '>= 0.35.1'
  gem 'chefspec',         '~> 4.4', '>= 4.4.0'
  gem 'foodcritic',       '~> 5.0', '>= 5.0.0'
end

group :integration do
  gem 'test-kitchen', '~> 1.4.2'
  gem 'kitchen-vagrant', '~> 0.19'
  gem 'kitchen-digitalocean'
  gem 'kitchen-ec2'
end

group :development do
  gem 'guard',            '~> 2.13.0'
  gem 'guard-rubocop',    '~> 1.2.0'
  gem 'guard-foodcritic', '~> 2.0.0'
  gem 'guard-kitchen',    '~> 0.0.2'
  gem 'guard-rspec',      '~> 4.6.4'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'terminal-notifier-guard', :require => false
  gem 'psych', '~> 2.0.15'
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /mswin|mingw|cygwin/i
    gem 'wdm', '>= 0.1.1'
    gem 'win32console'
  end
end
