# frozen_string_literal: true

class Slot < ApplicationRecord
  belongs_to :doctor
  has_one :appointment, dependent: :destroy

  validates :time, presence: true, uniqueness: { scope: :doctor_id }

  scope :available, -> { where.missing(:appointment) }
end
