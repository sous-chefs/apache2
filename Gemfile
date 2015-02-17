source 'https://rubygems.org'

gem 'berkshelf',  '~> 3.2', '>= 3.2.0'

group :unit do
  gem 'foodcritic',       '~> 4.0', '>= 4.0.0'
  gem 'rubocop',          '~> 0.29', '>= 0.29.0'
  gem 'chefspec',         '~> 4.2', '>= 4.2.0'
end

group :integration do
  gem 'test-kitchen', '~> 1.2'
  gem 'kitchen-vagrant', '~> 0.11'
  gem 'kitchen-digitalocean'
  gem 'kitchen-ec2'
end

group :development do
  gem 'guard',            '~> 2.12'
  gem 'guard-rubocop',    '~> 1.2'
  gem 'guard-foodcritic', '~> 1.0'
  gem 'guard-kitchen',    '~> 0.0'
  gem 'guard-rspec',      '~> 4.5'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'terminal-notifier-guard', :require => false
  gem 'psych', '~> 2.0.12'
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /mswin|mingw|cygwin/i
    gem 'wdm', '>= 0.1.0'
    gem 'win32console'
  end
end
