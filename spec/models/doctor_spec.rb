# frozen_string_literal: true

require "rails_helper"

RSpec.describe Doctor, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
