# frozen_string_literal: true

json.array! @appointments do |appointment|
  json.extract! appointment, :id, :time
  json.doctor do
    json.extract! appointment.doctor, :id, :name
  end
end
