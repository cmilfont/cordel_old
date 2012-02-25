ENV["RAILS_ENV"] ||= 'test'

#gem para coverage
require 'simplecov'
SimpleCov.start 'rails'

#carrega confs do Rails
require File.expand_path("../../config/environment", __FILE__)

#import do rspec
require 'rspec/rails'
require 'rspec/autorun'

#gem para fabricar models no Fixture Setup
require 'factory_girl'
#carrega todas as factories
Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}

#carrega demais helpers, handlers ou libs usados nos testes
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  
  config.mock_with :rspec

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation#, {:except => %w[ neighborhoods ]}
    DatabaseCleaner.clean
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end