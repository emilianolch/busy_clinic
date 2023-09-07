# frozen_string_literal: true

require "rails_helper"

RSpec.describe Slot, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:doctor) }
  end

  describe "validations" do
    subject { build(:slot) }

    it { is_expected.to validate_presence_of(:time) }
    it { is_expected.to validate_uniqueness_of(:time).scoped_to(:doctor_id) }
  end
end
