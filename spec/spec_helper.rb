require 'active_support/core_ext'
require 'pry'

RSpec.configure do |config|
  config.expect_with :rspec
end

$: << File.expand_path('../lib')
