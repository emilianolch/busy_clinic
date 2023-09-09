# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Doctors", type: :request do
  let(:auth_header) { { Authorization: create(:patient).token } }

  describe "GET /index" do
    let!(:doctors) { create_list(:doctor, 3) }

    it "renders a successful response" do
      get doctors_path, as: :json, headers: auth_header
      expect(response).to be_successful
    end

    it "renders a json list of doctors with their name and id" do
      get doctors_path, as: :json, headers: auth_header
      expect(response.body).to eq(doctors.to_json(only: [:id, :name]))
    end
  end

  describe "GET /show" do
    let(:doctor) { create(:doctor) }
    let!(:slots) { create_list(:slot, 3, doctor: doctor).sort_by(&:time) }

    it "renders a successful response" do
      get doctor_path(doctor), as: :json, headers: auth_header
      expect(response).to be_successful
    end

    it "renders a json of the doctor with their name, id and available slots" do
      get doctor_path(doctor), as: :json, headers: auth_header

      expect(response.parsed_body["id"]).to eq(doctor.id)
      expect(response.parsed_body["name"]).to eq(doctor.name)
      expect(response.parsed_body["available_slots"].map { |slot| slot["id"] })
        .to eq(slots.map(&:id))
    end
  end

  describe "GET /working_hours" do
    let(:doctor) { create(:doctor) }
    let!(:slots) { create_list(:slot, 3, doctor: doctor) }

    context "when date is provided" do
      it "renders a successful response" do
        get working_hours_doctor_path(doctor, date: Date.current), as: :json, headers: auth_header
        expect(response).to be_successful
      end

      it "renders a json of the doctor with their name, id and working hours for a given date" do
        get working_hours_doctor_path(doctor, date: Date.current), as: :json, headers: auth_header

        expect(response.parsed_body["id"]).to eq(doctor.id)
        expect(response.parsed_body["name"]).to eq(doctor.name)
        expect(response.parsed_body["working_hours"].size).to eq(slots.count { |s| s.time.to_date == Date.current })
      end
    end

    context "when date is not provided" do
      it "renders an error response" do
        get working_hours_doctor_path(doctor), as: :json, headers: auth_header
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
