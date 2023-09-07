# frozen_string_literal: true

json.extract! appointment, :id, :time
json.doctor do
  json.extract! appointment.doctor, :id, :name
end
