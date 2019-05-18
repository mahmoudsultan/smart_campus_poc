# frozen_string_literal: true

Rails.application.routes.draw do
  get 'admin/sign_up'
  get '/courses/years/' => 'courses#show_years'
  get '/courses/terms/' => 'courses#show_terms'
  get '/lectures/:term/:year' => 'courses#show_lectures'
  get '/lecture_instances/:lec_id' => 'lecture_instances#get_by_lec_id'
  get '/users/roles' => 'users#show_roles'
  get '/lecture_instances/status/:lec_id' => 'lecture_instances#get_attended_lectures_by_student'

  root to: 'courses#home'

  mount_devise_token_auth_for 'User', at: 'auth'
  as :user do
    # Define routes for User within this block.
    post '/auth/sign_in', to: 'devise_token_auth/sessions#create'
    delete '/auth/sign_out', to: 'devise_token_auth/sessions#destroy'
  end

  mount_devise_token_auth_for 'Admin', at: 'admin_auth'
  as :admin do
    # Define routes for Admin within this block.
    get '/admin_auth/sign_up', to: 'devise_token_auth/registrations#new'
    post '/admin_auth/sign_in', to: 'devise_token_auth/sessions#create'
    delete '/admin_auth/sign_out', to: 'devise_token_auth/sessions#destroy'
  end
  # For details on the DSL available within this file, see

  # Upload Image Route
  resources :users, only: [] do
    post 'image', to: 'users#upload_image'
  end
end
