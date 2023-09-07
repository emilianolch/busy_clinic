# frozen_string_literal: true

class Doctor < User
  has_many :slots, dependent: :destroy
  has_many :appointments, through: :slots
  has_many :patients, through: :appointments
end
