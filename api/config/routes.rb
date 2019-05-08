# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  mount_devise_token_auth_for 'Admin', at: 'TOwIWRgFHU'
  as :admin do
    # Define routes for Admin within this block.
  end
  # For details on the DSL available within this file, see

  scope 'attendance' do
    post 'new', to: 'attendances#new'
    post 'save', to: 'attendances#save'
    post 'update', to: 'attendances#update'
  end

  resources :students, only: %i[index create update destroy] do
    collection do
      get ':id', to: 'students#show'
      get '/sid/:student_id', to: 'students#show'
    end
  end

  resources :lecture_instances, only: [] do
    get 'place', to: 'lecture_instances#place'
    get 'students', to: 'lecture_instances#students'
    get 'attendance_sheet', to: 'lecture_instances#attendance_sheet'
  end

  # Upload Image Route
  resources :users, only: [] do
    post 'image', to: 'users#upload_image'
  end
end
