# frozen_string_literal: true

require "rails_helper"

RSpec.describe Slot, type: :model do
  subject { build(:slot) }

  describe "associations" do
    it { is_expected.to belong_to(:doctor) }
    it { is_expected.to have_one(:appointment).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:time) }
    it { is_expected.to validate_uniqueness_of(:time).scoped_to(:doctor_id) }

    it "avoids overlapping slots" do
      slot = create(:slot)
      expect(build(:slot, doctor: slot.doctor, time: slot.time - Slot::INTERVAL + 1.minute)).not_to be_valid
      expect(build(:slot, doctor: slot.doctor, time: slot.time + Slot::INTERVAL - 1.minute)).not_to be_valid
    end
  end

  describe "scopes" do
    describe ".available" do
      let!(:slot) { create(:slot) }
      let!(:available_slot) { create(:slot) }
      let!(:appointment) { create(:appointment, slot: slot) }

      it "returns slots that have no appointments" do
        expect(described_class.available).to eq([available_slot])
      end
    end
  end
end
