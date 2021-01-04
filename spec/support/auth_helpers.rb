module AuthHelpers
  module Request
    def login_user(user = FactoryBot.create(:user))
      send(:post, login_path, params: { user: { email: user.email, password: "foobar" } })
    end

    def logout
      send(:delete, logout_path)
    end
  end

  module Feature
    def login_user(user, current_page = page)
      current_page.visit login_path
      current_page.fill_in("user[email]", with: user.email)
      current_page.fill_in("user[password]", with: "foobar")
      current_page.click_on("Log in")
      current_page.has_content?(user.email)
    end

    def logout(current_page = page)
      current_page.driver.submit(:delete, logout_path)
    end
  end
end
