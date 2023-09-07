# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Doctors", type: :request do
  describe "GET /index" do
    let!(:doctors) { create_list(:doctor, 3) }

    it "renders a successful response" do
      get doctors_path, as: :json
      expect(response).to be_successful
    end

    it "renders a json list of doctors with their name and id" do
      get doctors_path, as: :json
      expect(response.body).to eq(doctors.to_json(only: [:id, :name]))
    end
  end

  describe "GET /show" do
    let(:doctor) { create(:doctor) }
    let!(:slots) { create_list(:slot, 3, doctor: doctor).sort_by(&:time) }

    it "renders a successful response" do
      get doctor_path(doctor), as: :json
      expect(response).to be_successful
    end

    it "renders a json of the doctor with their name, id and available slots" do
      get doctor_path(doctor), as: :json

      expect(response.body).to include_json(id: doctor.id, name: doctor.name)
      expect(response.body).to include_json(available_slots: slots.map { |slot| { id: slot.id } })
    end
  end
end
