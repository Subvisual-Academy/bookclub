require "rails_helper"

RSpec.feature "Authentication", js: true do
  it "Has the login option on root_path" do
    visit root_path

    expect(page).to have_content("Log In")
  end

  it "logins the user with correct credentials" do
    user = create(:user)

    visit login_path
    fill_in("Email", with: user.email)
    fill_in("Password", with: "foobar")
    click_on("LOG IN")

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Log Out")
  end

  it "rejects the user's login if the password is bad" do
    user = create(:user)

    visit login_path
    fill_in("Email", with: user.email)
    fill_in("Password", with: "bad password")
    click_on("LOG IN")

    expect(page).to have_current_path(login_path)
    expect(page).to have_content("Incorrect email/password")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
  end

  it "rejects the user's login if the email is bad" do
    user = create(:user)

    visit login_path
    fill_in("Email", with: "#{user.email}.bad")
    fill_in("Password", with: "bad password")
    click_on("LOG IN")

    expect(page).to have_current_path(login_path)
    expect(page).to have_content("Incorrect email/password")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
  end

  it "logs out the user" do
    user = create(:user)
    login_user(user)

    visit root_path
    click_on("Log Out")

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Log In")
  end
end
