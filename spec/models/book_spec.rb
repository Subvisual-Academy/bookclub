require "rails_helper"

RSpec.describe Book, type: :model do
  context "validation tests" do
    it "ensures title presence" do
      book = Book.new(author: "author", synopsis: "synopsis", image: "image.png")

      expect(book).not_to be_valid
    end

    it "ensures author presence" do
      book = Book.new(title: "title", synopsis: "synopsis", image: "image.png")

      expect(book).not_to be_valid
    end

    it "ensures synopsis presence" do
      book = Book.new(title: "title", author: "author", image: "image.png")

      expect(book).not_to be_valid
    end

    it "ensures image presence" do
      book = Book.new(title: "title", author: "author", synopsis: "synopsis")

      expect(book).not_to be_valid
    end
  end
end
