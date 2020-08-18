require "rails_helper"

RSpec.describe "Gatherings", type: :request do
  include ActionView::Helpers::SanitizeHelper
  it "displays all gatherings basic info" do
    allow(SlackNotifier).to receive(:publish).and_return(nil)
    gatherings_list = create_list(:gathering_with_book_presentations, 3, :has_special_presentation)

    get gatherings_path

    gatherings_list.each do |gathering|
      expect(response_text).to include(Date::MONTHNAMES[gathering.date.month])
      expect(response_text).to include(gathering.date.year.to_s)
    end
  end

  describe "GET #show" do
    it "displays the given gathering parameters when there's a special presentation" do
      gathering = create(:gathering_with_book_presentations, :has_special_presentation)

      get gathering_path(gathering)

      expect(response_text).to include(Date::MONTHNAMES[gathering.date.month])
      expect(response_text).to include(gathering.special_presentation)
      gathering.book_presentations.each do |book_presentation|
        expect(response_text).to include(book_presentation.user.name)
        expect(response_text).to include(book_presentation.book.title)
      end
    end
  end

  describe "GET #new" do
    it "redirects non logged user to login page" do
      get new_gathering_path

      expect(response).to redirect_to(login_path)
    end
  end

  it "displays the gathering form for logged in users" do
    user = create(:user)
    login_user(user)

    get new_gathering_path

    expect(response_text).to include("New Bookclub Gathering")
    expect(response_text).to include("Date")
    expect(response_text).to include("Book Mentions")
    expect(response_text).to include("Add Presentation")
  end

  describe "GET #edit" do
    it "redirects non logged user to login page" do
      gathering = create(:gathering_with_book_presentations)

      get edit_gathering_path(gathering)

      expect(response).to redirect_to(login_path)
    end

    it "displays gathering prameters to logged user" do
      user = create(:user)
      login_user(user)
      gathering = create(:gathering_with_book_presentations, :has_special_presentation)

      get edit_gathering_path(gathering)

      gathering.book_presentations.each do |book_presentation|
        expect(response_text).to include(book_presentation.user.name)
        expect(response_text).to include(book_presentation.book.title)
      end
    end
  end

  describe "POST #create" do
    before(:all) do
      @user = create(:user)
      login_user(@user)
    end

    it "redirects to gatherings_path on a successful creation" do
      book = create(:book)
      allow(SlackNotifier).to receive(:publish).and_return(nil)
      gathering_params = attributes_for(:gathering, :has_special_presentation)
      book_presentation_params = { "1" => { user_id: @user.id, book_id: book.id, belongs_special_presentation: true } }
      gathering_params["book_presentations_attributes"] = book_presentation_params

      post gatherings_path, params: { gathering: gathering_params }

      expect(response).to redirect_to(gatherings_path)
    end

    it "creates a gathering with the correct params" do
      book = create(:book)
      allow(SlackNotifier).to receive(:publish).and_return(nil)
      gathering_params = attributes_for(:gathering, :has_special_presentation)
      book_presentation_params = { "1" => { user_id: @user.id, book_id: book.id, belongs_special_presentation: true } }
      gathering_params["book_presentations_attributes"] = book_presentation_params

      post gatherings_path, params: { gathering: gathering_params }

      created_gathering = Gathering.last
      expect(created_gathering.date).to eq(gathering_params[:date])
      expect(created_gathering.special_presentation).to eq(gathering_params[:special_presentation])
      expect(created_gathering.book_presentations[0].user_id).to eq(book_presentation_params["1"][:user_id])
      expect(created_gathering.book_presentations[0].book_id).to eq(book_presentation_params["1"][:book_id])
      expect(created_gathering.book_presentations[0].belongs_special_presentation).to eq(book_presentation_params["1"][:belongs_special_presentation])
    end

    it "returns bad_request if create is unsuccessful" do
      allow(SlackNotifier).to receive(:publish).and_return(nil)

      post gatherings_path, params: { gathering: { date: "" } }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "PUT #update" do
    before(:all) do
      login_user(create(:user))
    end

    it "redirects to gathering_path on a successful update" do
      gathering = create(:gathering, :has_special_presentation)
      gathering_params = attributes_for(:gathering, :has_special_presentation)

      put gathering_path(gathering), params: { gathering: gathering_params }

      expect(response).to redirect_to(gathering_path(gathering))
    end

    it "updates parameter on successful patch" do
      gathering = create(:gathering, :has_special_presentation)
      gathering_params = attributes_for(:gathering, :has_special_presentation)

      put gathering_path(gathering), params: { gathering: gathering_params }

      gathering.reload
      expect(gathering.date).to eq(gathering_params[:date])
      expect(gathering.special_presentation).to eq(gathering_params[:special_presentation])
    end

    it "returns bad_request on an unsuccessful patch" do
      gathering = create(:gathering, :has_special_presentation)

      put gathering_path(gathering), params: { gathering: { date: 1 } }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "DELETE #destroy" do
    before(:all) do
      login_user(create(:user))
    end

    it "redirects to gatherings_path on a successful delete" do
      gathering = create(:gathering)

      delete gathering_path(gathering)

      expect(response).to redirect_to(gatherings_path)
    end

    it "destroys a gathering" do
      gathering = create(:gathering)

      delete gathering_path(gathering)

      expect(Gathering.count).to eq(0)
    end
  end
end
