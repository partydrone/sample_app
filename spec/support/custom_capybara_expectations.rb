module CustomCapybaraExpectations
  def has_flash_message?(message)
    within '#flash' do
      has_contnet? message
    end
  end
end

Capybara::Session.send :include, CustomCapybaraExpectations

CustomCapybaraExpectations.public_instance_methods(false).each do |name|
  CapybaraMiniTestSpec::Matcher.new(name)
end
