require "rails_helper"

RSpec.feature "Authentication", js: true do
  it "Has the log_in option on root_path" do
    visit root_path

    expect(page).to have_content("Log In")
  end

  it "logins the user with correct credentials" do
    user = create(:user)

    visit log_in_path
    fill_in("Email", with: user.email)
    fill_in("Password", with: "foobar")
    click_on("Log in")

    expect(page).to have_content("Logout")
    expect(current_path).to eq(root_path)
  end


end