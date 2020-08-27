require "rails_helper"

RSpec.feature "Gathering", js: true do
  it "displays a book presentation form when the button is clicked" do
    login_user(create(:user))

    visit new_gathering_path
    click_on("Add Presentation")

    expect(page).to have_content("User")
    expect(page).to have_content("Book")
  end

  it "displays the Gathering information when editing" do
    login_user(create(:user))
    gathering = create(:gathering_with_book_presentations, :has_special_presentation)

    visit(edit_gathering_path(gathering))

    expect(page.find("#gathering_date_1i").value).to eq gathering.date.year.to_s
    expect(page.find("#gathering_date_2i").value).to eq gathering.date.month.to_s
    expect(page.find("#gathering_date_3i").value).to eq gathering.date.day.to_s
    expect(find_field("Special Presentation Title").value).to eq(gathering.special_presentation)
  end

  it "creates a gathering" do
    login_user(create(:user))
    allow(SlackNotifier).to receive(:notify_minute).and_return(nil)

    visit(new_gathering_path)
    fill_in("Special Presentation Title", with: "test")
    click_on("Add Presentation")
    click_on("Submit")

    expect(page).to have_current_path(gatherings_path)
  end

  it "does not show the notification button to non moderators" do
    login_user(create(:user))
    gathering = create(:gathering)

    visit gathering_path(gathering)

    expect(page).not_to have_selector(:link_or_button, "Send Slack Notification")
  end

  it "shows the notification button to moderators" do
    login_user(create(:user, :is_moderator))
    gathering = create(:gathering)

    visit gathering_path(gathering)

    expect(page).to have_selector(:link_or_button, "Send Slack Notification")
  end
end
