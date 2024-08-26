# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "doctors" do
  # rubocop:disable RSpec/VariableName
  let(:Authorization) { create(:patient).token }
  # rubocop:enable RSpec/VariableName

  path "/doctors" do
    let!(:doctors) { create_list(:doctor, 3) }

    parameter name: "Authorization", in: :header, type: :string, description: "Authorization"

    get("list doctors") do
      response(200, "successful") do
        run_test! do |response|
          expect(response.body).to eq(doctors.to_json(only: [:id, :name]))
        end
      end
    end
  end

  path "/doctors/{id}" do
    let(:doctor) { create(:doctor) }
    let(:id) { doctor.id }
    let!(:slots) { create_list(:slot, 3, doctor: doctor).sort_by(&:time) }

    parameter name: "Authorization", in: :header, type: :string, description: "Authorization"
    parameter name: "id", in: :path, type: :string, description: "id"

    get("show doctor") do
      response(200, "successful") do
        run_test! do |response|
          expect(response.parsed_body["id"]).to eq(doctor.id)
          expect(response.parsed_body["name"]).to eq(doctor.name)
          expect(response.parsed_body["available_slots"].pluck("id")).to eq(slots.pluck(:id))
        end
      end
    end
  end

  path "/doctors/{id}/working_hours" do
    let(:doctor) { create(:doctor) }
    let(:id) { doctor.id }
    let!(:slots) { create_list(:slot, 3, doctor: doctor) }

    parameter name: "Authorization", in: :header, type: :string, description: "Authorization"
    parameter name: "id", in: :path, type: :string, description: "id"
    parameter name: :date, in: :query, type: :string, description: "date"

    get("working_hours doctor") do
      response(200, "successful") do
        let(:date) { Date.current }

        run_test! do |response|
          expect(response.parsed_body["id"]).to eq(doctor.id)
          expect(response.parsed_body["name"]).to eq(doctor.name)
          expect(response.parsed_body["working_hours"].size).to eq(slots.count { |s| s.time.to_date == Date.current })
        end
      end

      response(400, "bad request") do
        let(:date) { nil }

        run_test!
      end
    end
  end
end
