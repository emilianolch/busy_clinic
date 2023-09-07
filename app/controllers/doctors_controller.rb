# frozen_string_literal: true

class DoctorsController < ApplicationController
  def index
    render json: Doctor.all, only: [:id, :name]
  end

  def show
    @doctor = Doctor.find(params[:id])
  end
end
