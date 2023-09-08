# frozen_string_literal: true

class Doctor < User
  has_many :slots, dependent: :destroy
  has_many :appointments, through: :slots
  has_many :patients, through: :appointments

  def generate_slots(start_time, end_time)
    end_time -= Slot::INTERVAL

    (start_time.to_i..end_time.to_i).step(Slot::INTERVAL).map do |time|
      slots.create(time: Time.zone.at(time))
    end.select(&:persisted?)
  end
end
