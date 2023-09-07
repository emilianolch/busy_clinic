# frozen_string_literal: true

class AppointmentsController < ApplicationController
  before_action :require_patient!
  before_action :set_appointment, only: [:update, :destroy]

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
    if @appointment.update(appointment_params)
      render @appointment
    else
      render json: { errors: @appointment.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy

    head :no_content
  end

  private

  def set_appointment
    @appointment = current_user.appointments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ["Appointment not found"] }, status: :not_found
  end

  def appointment_params
    params.require(:appointment).permit(:slot_id)
  end
end
