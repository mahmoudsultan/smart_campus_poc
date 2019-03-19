# frozen_string_literal: true

Rails.application.routes.draw do
  get 'courses/show_lectures'
  mount_devise_token_auth_for 'User', at: 'auth'

  mount_devise_token_auth_for 'Admin', at: 'TOwIWRgFHU'
  as :admin do
    # Define routes for Admin within this block.
  end
  # For details on the DSL available within this file, see
end
