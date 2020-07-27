require "rails_helper"

RSpec.feature "Home Page", js: true do
  it "renders hello world" do
    visit root_path
  end
end
