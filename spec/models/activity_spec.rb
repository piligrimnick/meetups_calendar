require "rails_helper"

RSpec.describe Activity, type: :model do
  subject(:create_record) { described_class.create!(attributes) }
  let(:user) { create(:user) }
  let(:attributes) { attributes_for(:activity).merge(user_id: user.id) }

  let(:tommorow) { Time.zone.now + 1.day }

  it { is_expected.to have_attributes(attributes) }
  it { expect { create_record }.not_to raise_error }

  context "when user not given" do
    let(:attributes) { super().except(:user_id) }

    it { expect { create_record }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context "when user has intersecting activity in past" do
    let(:attributes) do
      super().merge(start_at: tommorow + 1.hour, end_at: tommorow + 3.hours)
    end

    before do
      create(:activity, user: user, start_at: tommorow, end_at: tommorow + 2.hours)
    end

    it { expect { create_record }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context "when user has intersecting activity in future" do
    let(:attributes) do
      super().merge(start_at: tommorow + 1.hour, end_at: tommorow + 3.hours)
    end

    before do
      create(:activity, user: user, start_at: tommorow + 2.hours, end_at: tommorow + 4.hours)
    end

    it { expect { create_record }.to raise_error(ActiveRecord::RecordInvalid) }
  end
end
