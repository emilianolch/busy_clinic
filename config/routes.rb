# frozen_string_literal: true

Rails.application.routes.draw do
  resources :doctors, only: [:index, :show]
  resources :appointments
end
