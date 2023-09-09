# frozen_string_literal: true

# == Schema Information
#
# Table name: slots
#
#  id         :integer          not null, primary key
#  time       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  doctor_id  :integer          not null
#
# Indexes
#
#  index_slots_on_doctor_id           (doctor_id)
#  index_slots_on_doctor_id_and_time  (doctor_id,time) UNIQUE
#
# Foreign Keys
#
#  doctor_id  (doctor_id => users.id)
#
class Slot < ApplicationRecord
  INTERVAL = 30.minutes

  belongs_to :doctor
  has_one :appointment, dependent: :destroy

  validates :time, presence: true
  validate :non_overlapping_validation

  scope :available,
    -> { where.missing(:appointment).where("time > ?", Time.current).order(:time) }

  private

  def non_overlapping_validation
    return if time.nil? || doctor.nil?

    if doctor.slots.where(time: (time - INTERVAL + 1)..(time + INTERVAL - 1)).where.not(id: id).any?
      errors.add(:time, "is overlapping with another slot")
    end
  end
end
