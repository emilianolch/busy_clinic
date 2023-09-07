# frozen_string_literal: true

FactoryBot.define do
  factory :doctor do
    name { Faker::Name.name }
  end
end
