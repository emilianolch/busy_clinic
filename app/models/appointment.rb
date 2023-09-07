# frozen_string_literal: true

class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :slot
  has_one :doctor, through: :slot

  validates :slot_id, uniqueness: true
end
