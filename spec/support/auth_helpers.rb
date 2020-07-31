module AuthHelpers
  module Request
    def log_in_user(user)
      send(:post, log_in_path, params: { email: user.email, password: "foobar" })
    end

    def log_out
      send(:delete, log_out_path)
    end
  end

  module Feature
    def log_in_user(user, current_page = page)
      current_page.visit log_in_path
      current_page.fill_in("Email", with: user.email)
      current_page.fill_in("Password", with: "foobar")
      current_page.click_on("LOG IN")
      current_page.has_content?(user.email)
    end

    def log_out(current_page = page)
      current_page.driver.submit(:delete, log_out_path)
    end
  end
end