# frozen_string_literal: true

class Doctor < User
  has_many :slots, dependent: :destroy
end
