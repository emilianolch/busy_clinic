# frozen_string_literal: true

class Slot < ApplicationRecord
  belongs_to :doctor
  has_one :appointment, dependent: :destroy

  validates :time, presence: true, uniqueness: { scope: :doctor_id }
  validate :non_overlapping_validation

  scope :available, -> { where.missing(:appointment) }

  private

  def non_overlapping_validation
    return if time.nil? || doctor.nil?

    if doctor.slots.where(time: (time - 30.minutes + 1)..(time + 30.minutes - 1)).where.not(id: id).any?
      errors.add(:time, "is overlapping with another slot")
    end
  end
end
