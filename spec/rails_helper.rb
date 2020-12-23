# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "database_cleaner"
require "capybara/rspec"
require "vcr"
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!

  require "transactional_capybara/rspec"
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr"
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.define_derived_metadata(file_path: Regexp.new("/spec/components/")) do |metadata|
    metadata[:type] = :component
  end

  config.include AuthHelpers::Request, type: :request
  config.include AuthHelpers::Feature, type: :feature
  config.include TransactionalCapybara::AjaxHelpers, type: :feature
  config.include DomHelpers, type: :feature
  config.include Capybara::RSpecMatchers, type: :component
  config.include HtmlHelpers, type: :request
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
