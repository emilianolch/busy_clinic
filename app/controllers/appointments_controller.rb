# frozen_string_literal: true

class AppointmentsController < ApplicationController
  before_action :require_patient!

  def index
    @appointments = current_user.appointments
      .includes(:slot, :doctor)
      .sort_by(&:time)
  end

  def create
    @appointment = current_user.appointments.build(appointment_params)

    if @appointment.save
      render @appointment, status: :created
    else
      render json: { errors: @appointment.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  def update
    @appointment = current_user.appointments.find(params[:id])

    if @appointment.update(appointment_params)
      render @appointment
    else
      render json: { errors: @appointment.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:slot_id)
  end
end
