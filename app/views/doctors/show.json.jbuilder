# frozen_string_literal: true

json.call(@doctor, :id, :name)
json.available_slots @doctor.slots.available, :id, :time
