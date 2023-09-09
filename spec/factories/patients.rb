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
FactoryBot.define do
  factory :patient do
    name { Faker::Name.name }
  end
end
