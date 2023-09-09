# frozen_string_literal: true

# Generate 2 doctors with a 6 hour schedule and a patient.
# The patient's token will be printed to the console, so you can use it to make requests.

Doctor.destroy_all
Patient.destroy_all

FactoryBot.create(:doctor).generate_slots(Time.zone.now, 6.hours.from_now)
FactoryBot.create(:doctor).generate_slots(Time.zone.now, 6.hours.from_now)

patient = FactoryBot.create(:patient)

puts "Patient token: #{patient.token}"
