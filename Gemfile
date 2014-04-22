source 'https://rubygems.org'

gem 'berkshelf',  '~> 2.0'

group :unit do
  gem 'foodcritic',       '~> 3.0'
  gem 'rubocop',          '~> 0.18.1'
  gem 'chefspec',         '~> 3.2.0'
end

group :integration do
  gem 'test-kitchen', '~> 1.2'
  gem 'kitchen-vagrant', '~> 0.11'
  gem 'kitchen-digitalocean'
  gem 'kitchen-ec2'
end

group :development do
  gem 'guard',            '~> 1.8'
  gem 'guard-rubocop',    '~> 0.2'
  gem 'guard-foodcritic', '~> 1.0'
  gem 'guard-kitchen',    '~> 0.0'
  gem 'guard-rspec',      '~> 3.0'
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'terminal-notifier-guard', :require => false
end
