ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'capybara/rails'
require 'database_cleaner'
require 'miniskirt'

Dir[File.expand_path('spec/support/*.rb')].each { |file| require file }
Dir[File.expand_path('spec/factories/*.rb')].each { |file| require file }

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown

  alias :method_name :__name__ if defined? :__name__

  before do
    DatabaseCleaner.clean
  end
end

class RequestSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
end
MiniTest::Spec.register_spec_type(/integration$/i, RequestSpec)

class ControllerSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include ActionController::TestCase::Behavior

  before do
    @routes = Rails.application.routes
  end
end
MiniTest::Spec.register_spec_type( /Controller$/, ControllerSpec )

class HelperTest < MiniTest::Spec
  include ActionView::TestCase::Behavior
end
MiniTest::Spec.register_spec_type(/Helper$/, HelperTest)

Turn.config do |c|
  c.format  = :outline
  c.natural = true
end
