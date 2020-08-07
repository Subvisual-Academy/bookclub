require "rails_helper"

RSpec.describe Book, type: :model do
  context "validation tests" do
    subject { build(:book) }

    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_presence_of(:author) }

    it { is_expected.to validate_presence_of(:synopsis) }

    it { is_expected.to validate_presence_of(:image) }

    it { is_expected.to validate_presence_of(:isbn) }
  end
end
