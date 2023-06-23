require "rails_helper"

RSpec.describe Admin do
  it { is_expected.to have_many(:refresh_tokens).dependent(:delete_all) }
end
