require "rails_helper"

RSpec.feature "Gathering", js: true do
  it "displays a book presentation form when the button is clicked" do
    login_user(create(:user, :moderator))

    visit new_gathering_path
    click_on("Add Presentation")

    expect(page).to have_css(".SlimSelect")
  end

  it "displays it's information when editing" do
    login_user(create(:user, :moderator))
    gathering = create(:gathering_with_book_presentations, :has_special_presentation)

    visit(edit_gathering_path(gathering))

    expect(page.find("#gathering_date").value).to eq gathering.date.to_s
    expect(find_field("Special Presentation Title").value).to eq(gathering.special_presentation)
  end

  it "creates a gathering" do
    login_user(create(:user, :moderator))
    allow(SlackNotifier).to receive(:notify_minute).and_return(nil)

    visit(new_gathering_path)
    fill_in("Special Presentation Title", with: "test")
    click_on("Add Presentation")
    click_on("Submit")

    expect(page).to have_current_path(gatherings_path)
  end

  it "does not show the notification button of a gathering to non moderators" do
    login_user(create(:user))
    gathering = create(:gathering_with_book_presentations, :has_special_presentation)

    visit gatherings_path
    find("p", text: Date::MONTHNAMES[gathering.date.month]).click

    expect(page).to_not have_selector("input[value='Send Slack Notification']")
  end

  it "shows the notification button to moderators" do
    login_user(create(:user, :moderator))
    gathering = create(:gathering_with_book_presentations, :has_special_presentation)

    visit gatherings_path
    find("p", text: Date::MONTHNAMES[gathering.date.month]).click

    expect(page).to have_selector("input[value='Send Slack Notification']")
  end

  it "does not display presentation information when a gathering is not clicked" do
    login_user(create(:user))
    gathering = create(:gathering_with_book_presentations, :has_special_presentation)

    visit gatherings_path

    expect(page).to_not have_text(gathering.books.first.title)
  end

  it "does display presentation information when a gathering is clicked" do
    login_user(create(:user))
    gathering = create(:gathering_with_book_presentations, :has_special_presentation)

    visit gatherings_path
    find("p", text: Date::MONTHNAMES[gathering.date.month]).click

    expect(page).to have_text(gathering.books.first.title)
  end

  it "closes a presentation when the close button is clicked" do
    login_user(create(:user))
    gathering = create(:gathering_with_book_presentations, :has_special_presentation)

    visit gatherings_path
    find("p", text: Date::MONTHNAMES[gathering.date.month]).click
    click_on("Close")

    expect(page).to_not have_text(gathering.books.first.title)
  end

  it "displays the book's synopsis when it's name is clicked" do
    login_user(create(:user))
    gathering = create(:gathering_with_book_presentations)

    visit gatherings_path
    find("p", text: Date::MONTHNAMES[gathering.date.month], match: :first).click
    find("span", class: "cursor-pointer", text: gathering.book_presentations[0].book.title).click

    expect(page).to have_content(gathering.book_presentations[0].book.synopsis)
  end
end
