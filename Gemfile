source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gem "administrate"
gem "bootsnap", ">= 1.4.2", require: false
gem "fuzzy_match", "~> 2.1"
gem "httparty", "~> 0.17"
gem "inline_svg"
gem "jbuilder", "~> 2.7"
gem "library_stdnums", "~> 1.6"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.3"
gem "rails", "~> 6.1"
gem "redis"
gem "sass-rails", ">= 6"
gem "slack-notifier"
gem "sorcery"
gem "turbo-rails"
gem "webpacker", "6.0.0.beta.2"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "vcr"
  gem "webmock"
end

group :development do
  gem "foreman"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara"
  gem "capybara-screenshot"
  gem "database_cleaner-active_record"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "transactional_capybara"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
