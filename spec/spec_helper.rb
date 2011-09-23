require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'database_cleaner'
  require 'forgery'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  VCR.config do |c|
    c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
    c.stub_with :fakeweb # or :webmock
  end

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = false

    config.include Factory::Syntax::Methods
    config.extend VCR::RSpec::Macros

    config.before do
      DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
      DatabaseCleaner.start
    end

    config.after do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  
end
