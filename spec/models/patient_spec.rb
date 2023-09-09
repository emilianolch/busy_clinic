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
require "rails_helper"

RSpec.describe Patient, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:appointments).dependent(:destroy) }
    it { is_expected.to have_many(:doctors).through(:appointments) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
