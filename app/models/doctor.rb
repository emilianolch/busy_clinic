# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  token      :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_token  (token) UNIQUE
#
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
