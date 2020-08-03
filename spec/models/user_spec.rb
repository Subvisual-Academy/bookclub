require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password) }
  it { is_expected.to validate_confirmation_of(:password) }

  it { is_expected.to validate_presence_of(:password_confirmation) }
  it { is_expected.to validate_length_of(:password_confirmation) }

  it "should not validate password if it's unchanged on existing record" do
    user = create(:user)

    user.password = nil
    user.save

    expect(user).to be_valid
  end

  it "should validate password if it's changed on existing record" do
    user = create(:user)

    user.password = "no_confirmation"
    user.save

    expect(user).to_not be_valid
  end
end
