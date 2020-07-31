require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET #new" do
    it "has a 200 status code" do
      get log_in_path

      expect(response.status).to eq(200)
    end

    it "redirects to root_path if already logged in" do
      user = create(:user)
      log_in_user(user)

      get log_in_path

      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #create" do
    it "redirects to root_path on a successful log_in" do
      user = create(:user)

      post log_in_path, params: { email: user.email, password: "foobar" }

      expect(response).to redirect_to(root_path)
    end

    it "return bad_request if log_in is bad" do
      user = create(:user)

      post log_in_path, params: { email: user.email, password: "bad_password" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE #destroy" do
    it "sends user to root_path after logging out" do
      user = create(:user)
      log_in_user(user)

      delete log_out_path

      expect(response).to redirect_to(root_path)
    end
  end

end
