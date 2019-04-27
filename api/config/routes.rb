# frozen_string_literal: true

Rails.application.routes.draw do
  get '/courses/years/' => 'courses#show_years'
  get '/courses/terms/' => 'courses#show_terms'
  get '/lectures/:term/:year' => 'courses#show_lectures'
  get '/lecture_instances/:lec_id' => 'lecture_instances#get_by_lec_id'
  root to: 'courses#home'

  mount_devise_token_auth_for 'User', at: 'auth'

  mount_devise_token_auth_for 'Admin', at: 'TOwIWRgFHU'
  as :admin do
    # Define routes for Admin within this block.
  end
  # For details on the DSL available within this file, see

  # Upload Image Route
  resources :users, only: [] do
    post 'image', to: 'users#upload_image'
  end
end
