require "rails_helper"

RSpec.describe "Notifications", type: :request do
  describe "POST #create" do
    it "non-logged users are redirected to login page" do
      gathering = create(:gathering)

      post gathering_notifications_path(gathering), params: { gathering_id: gathering.id }

      expect(response).to redirect_to(login_path)
    end

    it "returns unauthorized if user is not moderator" do
      login_user(create(:user))
      gathering = create(:gathering)

      post gathering_notifications_path(gathering), params: { gathering_id: gathering.id }

      expect(response).to have_http_status(:unauthorized)
    end

    it "redirects to gatherings_path on a successful notification" do
      allow(SlackNotifier).to receive(:notify_minute).and_return(nil)
      login_user(create(:user, :moderator))
      gathering = create(:gathering)

      post gathering_notifications_path(gathering), params: { gathering_id: gathering.id }

      expect(response).to redirect_to(gatherings_path)
    end
  end
end
