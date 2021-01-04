require "rails_helper"

RSpec.describe "Gatherings API", type: :request do
  describe "GET #index" do
    it "renders gatherings grouped by year" do
      gathering = create(:gathering_with_book_presentations)

      get api_gatherings_path

      expect(JSON.parse(response.body)).to include("data" => [gathering.as_json])
    end
  end

  describe "GET #show" do
    it "renders a single gathering" do
      gathering = create(:gathering_with_book_presentations)

      get api_gathering_path(gathering)

      expect(JSON.parse(response.body)).to eq(gathering.as_json.merge("books" => gathering.books.as_json))
    end
  end
end
