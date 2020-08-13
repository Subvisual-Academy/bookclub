require "rails_helper"

RSpec.feature "Bookclub_gathering", js: true do
  it "displays a book presentation form when the button is clicked" do
    login_user(create(:user))

    visit new_bookclub_gathering_path
    click_on("Add Presentation")

    expect(page).to have_content("User")
    expect(page).to have_content("Book")
  end

  it "displays the bookclub_gathering information when editing" do
    login_user(create(:user))
    gathering = create(:bookclub_gathering, :has_special_presentation)

    visit(edit_bookclub_gathering_path(gathering))

    expect(page.find("#bookclub_gathering_date_1i").value).to eq gathering.date.year.to_s
    expect(page.find("#bookclub_gathering_date_2i").value).to eq gathering.date.month.to_s
    expect(page.find("#bookclub_gathering_date_3i").value).to eq gathering.date.day.to_s
    expect(find_field("Special presentation").value).to eq(gathering.special_presentation)
  end

  it "creates a bookclub_gathering" do
    login_user(create(:user))
    allow(SlackNotifier).to receive(:publish).and_return(nil)

    visit(new_bookclub_gathering_path)
    fill_in("Special presentation", with: "test")
    click_on("Add Presentation")
    click_on("Create Bookclub gathering")

    expect(page).to have_current_path(bookclub_gatherings_path)
  end
end
