require "rails_helper"

RSpec.describe "BookclubGatherings", type: :request do
  include ActionView::Helpers::SanitizeHelper
  it "displays all book_gatherings basic info" do
    allow(SlackNotifier).to receive(:publish).and_return(nil)
    bookclub_gatherings_list = create_list(:bookclub_gathering_with_book_presentations, 3, :has_special_presentation)

    get bookclub_gatherings_path

    bookclub_gatherings_list.each do |bookclub_gathering|
      expect(response_text).to include(bookclub_gathering.date.to_s)
      expect(response_text).to include(bookclub_gathering.special_presentation)
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
    #todo mover para as features
#       expect(page).to have_selector("input[value='John']")
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
      user = create(:user)
      login_user(user)
      allow(SlackNotifier).to receive(:publish).and_return(nil)
      bookclub_gathering_params = attributes_for(:bookclub_gathering, :has_special_presentation)

      post bookclub_gatherings_path, params: { bookclub_gathering: bookclub_gathering_params }

      expect(response).to redirect_to(bookclub_gatherings_path)
    end
  end
end
