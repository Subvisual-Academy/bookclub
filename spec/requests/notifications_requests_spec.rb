require "rails_helper"

RSpec.describe "Notifications", type: :request do
  describe "POST #create" do
    it "redirects non logged user to login page" do
      gathering = create(:gathering)

      post gathering_notifications_path(gathering), params: { gathering_id: gathering.id }

      expect(response).to redirect_to(login_path)
    end
  end
end
