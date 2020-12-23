require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET #new" do
    it "has a 200 status code" do
      get login_path

      expect(response).to have_http_status(:ok)
    end

    it "redirects to root_path if already logged in" do
      user = create(:user)
      login_user(user)

      get login_path

      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #create" do
    it "redirects to root_path on a successful login" do
      user = create(:user)

      post login_path, params: { user: { email: user.email, password: "foobar" } }

      expect(response).to redirect_to(root_path)
    end

    it "redirects to login path on a failed login" do
      user = create(:user)

      post login_path, params: { user: { email: user.email, password: "bad_password" } }

      expect(response).to redirect_to(login_path(email: user.email))
    end
  end

  describe "DELETE #destroy" do
    it "sends user to root_path after logging out" do
      user = create(:user)
      login_user(user)

      delete logout_path

      expect(response).to redirect_to(root_path)
    end
  end
end
