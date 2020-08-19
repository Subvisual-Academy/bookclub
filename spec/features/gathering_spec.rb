require "rails_helper"

RSpec.feature "Gathering", js: true do
  before(:each) do
    login_user(create(:user))
  end
  it "displays a book presentation form when the button is clicked" do
    visit new_gathering_path
    click_on("Add Presentation")

    expect(page).to have_content("User")
    expect(page).to have_content("Book")
  end

  it "displays the Gathering information when editing" do
    gathering = create(:gathering_with_book_presentations, :has_special_presentation)

    visit(edit_gathering_path(gathering))

    expect(page.find("#gathering_date_1i").value).to eq gathering.date.year.to_s
    expect(page.find("#gathering_date_2i").value).to eq gathering.date.month.to_s
    expect(page.find("#gathering_date_3i").value).to eq gathering.date.day.to_s
    expect(find_field("Special Presentation Title").value).to eq(gathering.special_presentation)
  end

  it "creates a gathering" do
    allow(SlackNotifier).to receive(:publish).and_return(nil)

    visit(new_gathering_path)
    fill_in("Special Presentation Title", with: "test")
    click_on("Add Presentation")
    click_on("Submit")

    expect(page).to have_current_path(gatherings_path)
  end
end
