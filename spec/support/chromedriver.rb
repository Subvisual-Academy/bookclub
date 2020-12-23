require "selenium/webdriver"

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1368,768")
  options.add_argument("--headless")
  options.add_argument("--disable-gpu")

  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 options: options)
end

Capybara.default_driver = :chrome_headless
Capybara.javascript_driver = :chrome_headless
Capybara.ignore_hidden_elements = true
Capybara.default_max_wait_time = 1
