# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    patient
    slot
  end
end
