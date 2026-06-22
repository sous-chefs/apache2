# frozen_string_literal: true

require 'chefspec'
require 'chefspec/policyfile'
require_relative '../libraries/helpers'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
end
