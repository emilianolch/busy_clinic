# frozen_string_literal: true

json.array! @appointments do |appointment|
  render appointment
end
