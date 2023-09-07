# frozen_string_literal: true

class AppointmentsController < ApplicationController
  before_action :require_patient!

  def index
    @appointments = current_user.appointments
      .includes(:slot, :doctor)
      .sort_by(&:time)
  end
end
