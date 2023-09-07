# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request!

  attr_reader :current_user

  private

  def authenticate_request!
    @current_user = User.find_by(token: request.headers["Authorization"])
    render json: { error: "Not Authorized" }, status: :unauthorized unless @current_user
  end
end
