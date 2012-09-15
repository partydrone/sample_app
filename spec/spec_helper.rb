ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'active_support/testing/setup_and_teardown'

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown

  alias :method_name :__name__ if defined? :__name__
end

class HelperTest < MiniTest::Spec
  include ActionView::TestCase::Behavior
end
MiniTest::Spec.register_spec_type(/Helper$/, HelperTest)

Turn.config do |c|
  c.format  = :outline
  c.natural = true
end
