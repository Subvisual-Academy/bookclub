require "rails_helper"

RSpec.describe "BookclubGatherings", type: :request do
  include ActionView::Helpers::SanitizeHelper
  it "displays all book_gatherings basic info" do
    allow(SlackNotifier).to receive(:publish).and_return(nil)
    bookclub_gatherings_list = create_list(:bookclub_gathering_with_book_presentations, 3, :has_special_presentation)

    get bookclub_gatherings_path

    bookclub_gatherings_list.each do |bookclub_gathering|
      expect(response_text).to include(Date::MONTHNAMES[bookclub_gathering.date.month])
      expect(response_text).to include(bookclub_gathering.date.year.to_s)
    end
  end

  describe "GET #show" do
    it "displays the given book_gathering parameters when there's a special presentation" do
      bookclub_gathering = create(:bookclub_gathering_with_book_presentations, :has_special_presentation)

      get bookclub_gathering_path(bookclub_gathering)

      expect(response_text).to include(bookclub_gathering.date.to_s)
      expect(response_text).to include(bookclub_gathering.special_presentation)
      bookclub_gathering.book_presentations.each do |book_presentation|
        expect(response_text).to include(book_presentation.user.name)
        expect(response_text).to include(book_presentation.book.title)
      end
    end
  end

  describe "GET #new" do
    it "redirects non logged user to login page" do
      get new_bookclub_gathering_path

      expect(response).to redirect_to(login_path)
    end
  end

  it "displays the bookclub gathering form for logged in users" do
    user = create(:user)
    login_user(user)

    get new_bookclub_gathering_path

    expect(response_text).to include("New Bookclub Gathering")
    expect(response_text).to include("Date")
    expect(response_text).to include("Presentations")
    expect(response_text).to include("Add Presentation")
  end

  describe "GET #edit" do
    it "redirects non logged user to login page" do
      bookclub_gathering = create(:bookclub_gathering_with_book_presentations)

      get edit_bookclub_gathering_path(bookclub_gathering)

      expect(response).to redirect_to(login_path)
    end

    it "displays bookclub gathering prameters to logged user" do
      user = create(:user)
      login_user(user)
      bookclub_gathering = create(:bookclub_gathering_with_book_presentations, :has_special_presentation)

      get edit_bookclub_gathering_path(bookclub_gathering)

      bookclub_gathering.book_presentations.each do |book_presentation|
        expect(response_text).to include(book_presentation.user.name)
        expect(response_text).to include(book_presentation.book.title)
      end
    end
  end

  describe "POST #create" do
    it "redirects to bookclub_gatherings_path on a successful creation" do
      book = create(:book)
      user = create(:user)
      login_user(user)
      allow(SlackNotifier).to receive(:publish).and_return(nil)
      bookclub_gathering_params = attributes_for(:bookclub_gathering, :has_special_presentation)
      book_presentation_params = { "1" => { user_id: user.id, book_id: book.id, belongs_special_presentation: true } }
      bookclub_gathering_params["book_presentations_attributes"] = book_presentation_params

      post bookclub_gatherings_path, params: { bookclub_gathering: bookclub_gathering_params }

      expect(response).to redirect_to(bookclub_gatherings_path)
    end

    it "creates a bookclub_gathering with the correct params" do
      book = create(:book)
      user = create(:user)
      login_user(user)
      allow(SlackNotifier).to receive(:publish).and_return(nil)
      bookclub_gathering_params = attributes_for(:bookclub_gathering, :has_special_presentation)
      book_presentation_params = { "1" => { user_id: user.id, book_id: book.id, belongs_special_presentation: true } }
      bookclub_gathering_params["book_presentations_attributes"] = book_presentation_params

      post bookclub_gatherings_path, params: { bookclub_gathering: bookclub_gathering_params }

      created_gathering = BookclubGathering.last
      expect(created_gathering.date).to eq(bookclub_gathering_params[:date])
      expect(created_gathering.special_presentation).to eq(bookclub_gathering_params[:special_presentation])
      expect(created_gathering.book_presentations[0].user_id).to eq(book_presentation_params["1"][:user_id])
      expect(created_gathering.book_presentations[0].book_id).to eq(book_presentation_params["1"][:book_id])
      expect(created_gathering.book_presentations[0].belongs_special_presentation).to eq(book_presentation_params["1"][:belongs_special_presentation])
    end

    it "returns bad_request if create is unsuccessful" do
      user = create(:user)
      login_user(user)
      allow(SlackNotifier).to receive(:publish).and_return(nil)

      post bookclub_gatherings_path, params: { bookclub_gathering: { date: "" } }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "PUT #update" do
    it "redirects to bookclub_gathering_path on a successful update" do
      user = create(:user)
      login_user(user)
      gathering = create(:bookclub_gathering, :has_special_presentation)
      bookclub_gathering_params = attributes_for(:bookclub_gathering, :has_special_presentation)

      put bookclub_gathering_path(gathering), params: { bookclub_gathering: bookclub_gathering_params }

      expect(response).to redirect_to(bookclub_gathering_path(gathering))
    end

    it "updates parameter on successful patch" do
      user = create(:user)
      login_user(user)
      gathering = create(:bookclub_gathering, :has_special_presentation)
      bookclub_gathering_params = attributes_for(:bookclub_gathering, :has_special_presentation)

      put bookclub_gathering_path(gathering), params: { bookclub_gathering: bookclub_gathering_params }

      gathering.reload
      expect(gathering.date).to eq(bookclub_gathering_params[:date])
      expect(gathering.special_presentation).to eq(bookclub_gathering_params[:special_presentation])
    end

    it "returns bad_request on an unsuccessful patch" do
      user = create(:user)
      login_user(user)
      gathering = create(:bookclub_gathering, :has_special_presentation)

      put bookclub_gathering_path(gathering), params: { bookclub_gathering: { date: 1 } }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "DELETE #destroy" do
    it "redirects to bookclub_gatherings_path on a successful delete" do
      user = create(:user)
      login_user(user)
      bookclub_gathering = create(:bookclub_gathering)

      delete bookclub_gathering_path(bookclub_gathering)

      expect(response).to redirect_to(bookclub_gatherings_path)
    end

    it "destroys a bookclub_gathering" do
      user = create(:user)
      login_user(user)
      bookclub_gathering = create(:bookclub_gathering)

      delete bookclub_gathering_path(bookclub_gathering)

      expect(BookclubGathering.count).to eq(0)
    end
  end
end
