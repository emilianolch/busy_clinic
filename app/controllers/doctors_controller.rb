# frozen_string_literal: true

class DoctorsController < ApplicationController
  before_action :set_doctor, only: [:show, :working_hours]

  def index
    render json: Doctor.all, only: [:id, :name]
  end

  def show; end

  def working_hours
    @slots = @doctor.slots.where("DATE(time) = ?", Date.parse(params[:date]))
  rescue Date::Error => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:id])
  end
end
