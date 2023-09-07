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

  describe "POST /create" do
    let(:slot) { create(:slot) }

    context "with valid parameters" do
      let(:params) { { appointment: { slot_id: slot.id } } }

      context "when slot is available" do
        it "creates a new Appointment" do
          expect do
            post appointments_path, params: params, headers: auth_header, as: :json
          end.to change(Appointment, :count).by(1)
        end

        it "renders a JSON response with the new appointment" do
          post appointments_path, params: params, headers: auth_header, as: :json
          expect(response).to have_http_status(:created)
          expect(response.parsed_body["id"]).to eq(Appointment.last.id)
        end
      end

      context "when slot is not available" do
        before { create(:appointment, slot: slot) }

        it "does not create a new Appointment" do
          expect do
            post appointments_path, params: params, headers: auth_header, as: :json
          end.not_to change(Appointment, :count)
        end

        it "renders a JSON response with errors for the new appointment" do
          post appointments_path, params: params, headers: auth_header, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body["errors"]).to eq(["Slot has already been taken"])
        end
      end
    end

    context "with invalid parameters" do
      let(:params) { { appointment: { slot_id: nil } } }

      it "does not create a new Appointment" do
        expect do
          post appointments_path, params: params, headers: auth_header, as: :json
        end.not_to change(Appointment, :count)
      end

      it "renders a JSON response with errors for the new appointment" do
        post appointments_path, params: params, headers: auth_header, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["errors"]).to eq(["Slot must exist"])
      end
    end
  end

  describe "PATCH /update" do
    let(:appointment) { create(:appointment, patient: patient) }
    let(:slot) { create(:slot) }

    context "with valid parameters" do
      let(:params) { { appointment: { slot_id: slot.id } } }

      context "when new slot is available" do
        it "updates the requested appointment" do
          patch appointment_path(appointment), params: params, headers: auth_header, as: :json
          appointment.reload
          expect(appointment.slot).to eq(slot)
        end

        it "renders a JSON response with the appointment" do
          patch appointment_path(appointment), params: params, headers: auth_header, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["id"]).to eq(appointment.id)
        end
      end

      context "when new slot is not available" do
        before { create(:appointment, slot: slot) }

        it "does not update the requested appointment" do
          patch appointment_path(appointment), params: params, headers: auth_header, as: :json
          appointment.reload
          expect(appointment.slot).not_to eq(slot)
        end

        it "renders a JSON response with errors for the appointment" do
          patch appointment_path(appointment), params: params, headers: auth_header, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body["errors"]).to eq(["Slot has already been taken"])
        end
      end

      context "when appointment does not belong to patient" do
        let(:appointment) { create(:appointment) }

        it "does not update the requested appointment" do
          patch appointment_path(appointment), params: params, headers: auth_header, as: :json
          appointment.reload
          expect(appointment.slot).not_to eq(slot)
        end

        it "renders a JSON response with errors for the appointment" do
          patch appointment_path(appointment), params: params, headers: auth_header, as: :json
          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body["errors"]).to eq(["Appointment not found"])
        end
      end
    end

    context "with invalid parameters" do
      let(:params) { { appointment: { slot_id: nil } } }

      it "renders a JSON response with errors for the appointment" do
        patch appointment_path(appointment), params: params, headers: auth_header, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["errors"]).to eq(["Slot must exist"])
      end
    end
  end

  describe "DELETE /destroy" do
    context "when appointment belongs to patient" do
      let!(:appointment) { create(:appointment, patient: patient) }

      it "destroys the requested appointment" do
        expect do
          delete appointment_path(appointment), headers: auth_header, as: :json
        end.to change(Appointment, :count).by(-1)
      end

      it "renders a no content" do
        delete appointment_path(appointment), headers: auth_header, as: :json
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when appointment does not belong to patient" do
      let!(:appointment) { create(:appointment) }

      it "does not destroy the requested appointment" do
        expect do
          delete appointment_path(appointment), headers: auth_header, as: :json
        end.not_to change(Appointment, :count)
      end

      it "renders a JSON response with errors for the appointment" do
        delete appointment_path(appointment), headers: auth_header, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body["errors"]).to eq(["Appointment not found"])
      end
    end
  end
end
