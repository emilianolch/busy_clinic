# frozen_string_literal: true

json.call(@doctor, :id, :name)
json.working_hours @slots, :id, :time
