# frozen_string_literal: true

class Slot < ApplicationRecord
  belongs_to :doctor

  validates :time, presence: true, uniqueness: { scope: :doctor_id }
end
