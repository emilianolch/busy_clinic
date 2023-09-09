# frozen_string_literal: true

# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  patient_id :integer          not null
#  slot_id    :integer          not null
#
# Indexes
#
#  index_appointments_on_patient_id  (patient_id)
#  index_appointments_on_slot_id     (slot_id) UNIQUE
#
# Foreign Keys
#
#  patient_id  (patient_id => users.id)
#  slot_id     (slot_id => slots.id)
#
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
