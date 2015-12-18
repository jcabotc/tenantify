require 'pry'

RSpec.configure do |config|

  # Restore the original tenant after each test
  config.around :each do |example|
    begin
      original_value = Thread.current[:tenant]
      example.run
    ensure
      Thread.current[:tenant] = original_value
    end
  end

  config.expect_with :rspec do |expectations|
    # Best error messages on chained expectations
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from stubbing a method that does not exist on a real object
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.order = :random

end
