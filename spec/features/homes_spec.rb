require "rails_helper"

RSpec.feature "Home Page", js: true do
  it "renders the expected text" do
    visit root_path

    expect(page).to have_content("Next BookClub session: ")
  end
end
