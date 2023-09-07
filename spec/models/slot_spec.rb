# frozen_string_literal: true

require "rails_helper"

RSpec.describe Slot, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:doctor) }
    it { is_expected.to have_one(:appointment).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:slot) }

    it { is_expected.to validate_presence_of(:time) }
    it { is_expected.to validate_uniqueness_of(:time).scoped_to(:doctor_id) }
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
