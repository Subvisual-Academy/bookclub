require "rails_helper"

RSpec.describe Book, type: :model do
  context "validation tests" do
    subject { build(:book) }

    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_presence_of(:author) }

    it { is_expected.to validate_presence_of(:synopsis) }

    it { is_expected.to validate_presence_of(:image) }

    it { is_expected.to validate_presence_of(:google_id) }

    it { is_expected.to validate_uniqueness_of(:google_id) }
  end
end
