require "rails_helper"

RSpec.describe "Gatherings", type: :request do
  include ActionView::Helpers::SanitizeHelper

  it "displays all gatherings basic info" do
    gatherings_list = create_list(:gathering_with_book_presentations, 3, :has_special_presentation)

    get gatherings_path

    gatherings_list.each do |gathering|
      expect(response_text).to include(Date::MONTHNAMES[gathering.date.month])
      expect(response_text).to include(gathering.date.year.to_s)
    end
  end

  it "displays the next gathering date" do
    get gatherings_path

    expect(response_text).to include(Gathering.next_gathering_date.strftime("%A, %d %B %Y"))
  end

  it "displays the full information about all the gatherings" do
    gathering_list = create_list(:gathering_with_book_presentations, 3, :has_special_presentation)

    get gatherings_path

    gathering_list.each do |gathering|
      expect(response_text).to include(Date::MONTHNAMES[gathering.date.month])
      expect(response_text).to include(gathering.special_presentation)
    end
  end

  describe "GET #new" do
    it "redirects non logged user to login page" do
      get new_gathering_path

      expect(response).to redirect_to(login_path)
    end

    it "returns unauthorized if user isn't moderator" do
      login_user(create(:user))

      get new_gathering_path

      expect(response).to have_http_status(:unauthorized)
    end

    it "displays the gathering form for moderators" do
      user = create(:user, :moderator)
      login_user(user)

      get new_gathering_path

      expect(response_text).to include("New Bookclub Gathering")
      expect(response_text).to include("Date")
      expect(response_text).to include("Book Mentions")
      expect(response_text).to include("Add Presentation")
    end
  end

  describe "GET #edit" do
    it "displays gathering prameters to logged user" do
      user = create(:user, :moderator)
      login_user(user)
      gathering = create(:gathering_with_book_presentations, :has_special_presentation)

      get edit_gathering_path(gathering)

      gathering.book_presentations.each do |book_presentation|
        expect(response_text).to include(book_presentation.user.name)
        expect(response_text).to include(book_presentation.book.title)
      end
    end

    it "redirects non logged user to login page" do
      gathering = create(:gathering_with_book_presentations)

      get edit_gathering_path(gathering)

      expect(response).to redirect_to(login_path)
    end

    it "returns unauthorized if user isn't moderator" do
      gathering = create(:gathering_with_book_presentations)
      login_user(create(:user))

      get edit_gathering_path(gathering)

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST #create" do
    it "creates a gathering successfully" do
      user = create(:user, :moderator)
      book = create(:book)
      login_user(user)
      gathering_params = attributes_for(:gathering, :has_special_presentation)
      book_presentation_params = { "1" => { user_id: user.id, book_id: book.id, special: true } }
      gathering_params["book_presentations_attributes"] = book_presentation_params

      post gatherings_path, params: { gathering: gathering_params }

      created_gathering = Gathering.last
      expect(created_gathering.date).to eq(gathering_params[:date])
      expect(created_gathering.special_presentation).to eq(gathering_params[:special_presentation])
      expect(created_gathering.book_presentations[0].user_id).to eq(book_presentation_params["1"][:user_id])
      expect(created_gathering.book_presentations[0].book_id).to eq(book_presentation_params["1"][:book_id])
      expect(created_gathering.book_presentations[0].special).to eq(book_presentation_params["1"][:special])
      expect(response).to redirect_to(gatherings_path)
    end

    it "redirects to new if params are invalid" do
      user = create(:user, :moderator)
      login_user(user)

      post gatherings_path, params: { gathering: { date: "" } }

      expect(Gathering.last).to be_falsey
      expect(response).to redirect_to(new_gathering_path)
    end

    it "redirects non logged user to login page" do
      user = create(:user)
      book = create(:book)
      gathering_params = attributes_for(:gathering, :has_special_presentation)
      book_presentation_params = { "1" => { user_id: user.id, book_id: book.id, special: true } }
      gathering_params["book_presentations_attributes"] = book_presentation_params

      post gatherings_path, params: { gathering: gathering_params }

      expect(response).to redirect_to(login_path)
    end

    it "returns unauthorized if user isn't moderator" do
      user = create(:user)
      book = create(:book)
      login_user(create(:user))
      gathering_params = attributes_for(:gathering, :has_special_presentation)
      book_presentation_params = { "1" => { user_id: user.id, book_id: book.id, special: true } }
      gathering_params["book_presentations_attributes"] = book_presentation_params

      post gatherings_path, params: { gathering: gathering_params }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PUT #update" do
    it "successfully updates a gathering" do
      login_user(create(:user, :moderator))
      gathering = create(:gathering, :has_special_presentation)
      gathering_params = attributes_for(:gathering, :has_special_presentation)

      put gathering_path(gathering), params: { gathering: gathering_params }

      gathering.reload
      expect(gathering.date).to eq(gathering_params[:date])
      expect(gathering.special_presentation).to eq(gathering_params[:special_presentation])
      expect(response).to redirect_to(gatherings_path)
    end

    it "redirects to edit if params are invalid" do
      login_user(create(:user, :moderator))
      gathering = create(:gathering, :has_special_presentation)

      put gathering_path(gathering), params: { gathering: { date: "INVALID" } }

      expect(Gathering.last).to eq(gathering)
      expect(response).to redirect_to(edit_gathering_path)
    end

    it "redirects non logged user to login page" do
      gathering = create(:gathering, :has_special_presentation)
      gathering_params = attributes_for(:gathering, :has_special_presentation)

      put gathering_path(gathering), params: { gathering: gathering_params }

      expect(response).to redirect_to(login_path)
    end

    it "returns unauthorized if user isn't moderator" do
      login_user(create(:user))
      gathering = create(:gathering, :has_special_presentation)
      gathering_params = attributes_for(:gathering, :has_special_presentation)

      put gathering_path(gathering), params: { gathering: gathering_params }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE #destroy" do
    it "redirects to gatherings_path on a successful delete" do
      login_user(create(:user, :moderator))
      gathering = create(:gathering)

      delete gathering_path(gathering)

      expect(response).to redirect_to(gatherings_path)
    end

    it "destroys a gathering" do
      login_user(create(:user, :moderator))
      gathering = create(:gathering)

      delete gathering_path(gathering)

      expect(Gathering.count).to eq(0)
    end

    it "redirects non logged user to login page" do
      gathering = create(:gathering)

      delete gathering_path(gathering)

      expect(Gathering.count).to eq(1)
      expect(response).to redirect_to(login_path)
    end

    it "returns unauthorized if user isn't moderator" do
      login_user(create(:user))
      gathering = create(:gathering)

      delete gathering_path(gathering)

      expect(Gathering.count).to eq(1)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
