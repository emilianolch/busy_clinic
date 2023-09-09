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
FactoryBot.define do
  factory :slot do
    doctor

    sequence(:time) { |n| Time.current + (n * 30).minutes }
  end
end
