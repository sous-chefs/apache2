require 'chefspec'
require 'chefspec/berkshelf'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true

  # Specify the path for Chef Solo to find roles (default: [ascending search])
  # config.role_path = '/var/roles'

  # Specify the Chef log_level (default: :warn)
  # config.log_level = :info
end
