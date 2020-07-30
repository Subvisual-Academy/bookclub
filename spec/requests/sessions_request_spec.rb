require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET #new" do
    it "has a 200 status code" do
      get log_in_path

      expect(response.body).to include("Log In")
      expect(response.body).to include("Email")
      expect(response.body).to include("Password")
    end

    it "redirects to root_path if already logged in" do
      user = create(:user)
      log_in_user(user)

      get log_in_path

      expect(response).to redirect_to(root_path)
    end

  end
end
