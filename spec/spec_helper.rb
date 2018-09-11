require 'chefspec'
require 'chefspec/berkshelf'
require_relative '../libraries/helpers'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
end
