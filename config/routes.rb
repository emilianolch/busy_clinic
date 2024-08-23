# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :doctors, only: [:index, :show] do
    get :working_hours, on: :member
  end
  resources :appointments
end
