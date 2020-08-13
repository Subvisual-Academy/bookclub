require "rails_helper"

RSpec.describe Gathering, type: :model do
  subject { build(:gathering_with_book_presentations, :has_special_presentation) }

  it { is_expected.to validate_presence_of :date }

  it { should accept_nested_attributes_for(:book_presentations).allow_destroy(true) }

  it "rejects blank user_id field" do
    anaf_book_presentations = Gathering.nested_attributes_options[:book_presentations]
    expect(anaf_book_presentations[:reject_if].call({ "user_id" => "",
                                                      "book_id" => 1,
                                                      "belongs_special_presentation" => true })).to be_truthy
  end

  it "rejects blank user_id field" do
    anaf_book_presentations = Gathering.nested_attributes_options[:book_presentations]
    expect(anaf_book_presentations[:reject_if].call({ "user_id" => "",
                                                      "book_id" => 1,
                                                      "belongs_special_presentation" => true })).to be_truthy
  end
end
