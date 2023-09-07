# frozen_string_literal: true

require "rails_helper"

RSpec.describe Doctor, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:slots).dependent(:destroy) }
    it { is_expected.to have_many(:appointments).through(:slots) }
    it { is_expected.to have_many(:patients).through(:appointments) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
