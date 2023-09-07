# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Appointments", type: :request do
  let(:patient) { create(:patient) }
  let(:auth_header) { { Authorization: patient.token } }

  describe "GET /index" do
    let!(:appointments) { create_list(:appointment, 3, patient: patient) }

    it "renders a successful response" do
      get appointments_path, as: :json, headers: auth_header
      expect(response).to be_successful
    end

    it "renders a json list of appointments with their id, time, doctor name and doctor id" do
      get appointments_path, as: :json, headers: auth_header
      response.parsed_body.each_with_index do |appointment, index|
        expect(appointment["id"]).to eq(appointments[index].id)
        expect(Time.zone.parse(appointment["time"]).round).to eq(appointments[index].time.round)
        expect(appointment["doctor"]["id"]).to eq(appointments[index].doctor.id)
        expect(appointment["doctor"]["name"]).to eq(appointments[index].doctor.name)
      end
    end
  end
end
