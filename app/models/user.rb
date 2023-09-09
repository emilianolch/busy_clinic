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
class User < ApplicationRecord
  has_secure_token

  validates :name, presence: true
end
