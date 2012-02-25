require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require "paperclip/matchers"
require 'factory_girl'
Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  
  config.mock_with :rspec

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation#, {:except => %w[ neighborhoods ]}
    DatabaseCleaner.clean
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  
  config.include Paperclip::Shoulda::Matchers
  
end