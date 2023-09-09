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
class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :slot
  has_one :doctor, through: :slot

  validates :slot_id, uniqueness: true

  delegate :time, to: :slot
end
