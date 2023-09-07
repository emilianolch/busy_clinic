# frozen_string_literal: true

require "rails_helper"

RSpec.describe Appointment, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:slot) }
    it { is_expected.to belong_to(:patient) }
    it { is_expected.to have_one(:doctor).through(:slot) }
  end

  describe "validations" do
    subject { build(:appointment) }

    it { is_expected.to validate_uniqueness_of(:slot_id) }
  end
end
