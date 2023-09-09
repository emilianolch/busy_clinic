# frozen_string_literal: true

Rails.application.routes.draw do
  resources :doctors, only: [:index, :show] do
    get :working_hours, on: :member
  end
  resources :appointments
end
