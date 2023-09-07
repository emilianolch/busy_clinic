# frozen_string_literal: true

FactoryBot.define do
  factory :slot do
    doctor

    sequence(:time) { |n| Time.current + (n * 30).minutes }
  end
end
