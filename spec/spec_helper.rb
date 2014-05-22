require 'simplecov'

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

SimpleCov.start do
  add_filter 'spec'
end
