require "rails_helper"

RSpec.describe BookPresentation, type: :model do
  subject { build(:book_presentation) }

  it { is_expected.to validate_presence_of(:user_id) }

  it { is_expected.to validate_presence_of(:book_id) }
end
