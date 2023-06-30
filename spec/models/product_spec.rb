require "rails_helper"

RSpec.describe Product do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

  it { is_expected.to belong_to(:category) }
end
