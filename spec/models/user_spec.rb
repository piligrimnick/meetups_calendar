require "rails_helper"

RSpec.describe User, type: :model do
  subject(:create_record) { described_class.create!(attributes) }
  let(:attributes) { attributes_for(:user) }

  it { is_expected.to have_attributes(attributes) }
  it { expect { create_record }.not_to raise_error }
end
