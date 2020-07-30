require "rails_helper"

RSpec.describe Book, type: :model do
  context "validation tests" do
    it "ensure title presence" do
      book = build(:book, title: nil)

      expect(book).not_to be_valid
    end

    it "ensure author presence" do
      book = build(:book, author: nil)

      expect(book).not_to be_valid
    end

    it "ensure synopsis presence" do
      book = build(:book, synopsis: nil)

      expect(book).not_to be_valid
    end

    it "ensure image presence" do
      book = build(:book, image: nil)

      expect(book).not_to be_valid
    end
  end
end
