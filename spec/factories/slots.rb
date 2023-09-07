# frozen_string_literal: true

FactoryBot.define do
  factory :slot do
    doctor

    time { Faker::Time.between(from: Time.current, to: Time.current + 10.days) } # rubocop:disable Rails/DurationArithmetic
  end
end
