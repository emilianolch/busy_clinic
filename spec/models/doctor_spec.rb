# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  token      :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_token  (token) UNIQUE
#
require "rails_helper"

RSpec.describe Doctor, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:slots).dependent(:destroy) }
    it { is_expected.to have_many(:appointments).through(:slots) }
    it { is_expected.to have_many(:patients).through(:appointments) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#generate_slots" do
    subject(:doctor) { create(:doctor) }

    it "creates slots for the given time range" do
      expect do
        doctor.generate_slots(Time.current, 1.day.from_now)
      end.to change(doctor.slots, :count).by(48)
    end

    it "returns the created slots" do
      expect(
        doctor.generate_slots(Time.current, 1.day.from_now),
      ).to all(be_a(Slot))
    end

    it "does not create slots that already exist" do
      create(:slot, doctor: doctor, time: Time.current)
      expect do
        doctor.generate_slots(Time.current, 1.day.from_now)
      end.to change(Slot, :count).by(47)
    end
  end
end
