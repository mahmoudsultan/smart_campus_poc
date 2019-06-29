# frozen_string_literal: true

Rails.application.routes.draw do
  post 'admin/create_user' => 'admin#create_user'
  get '/courses/years/' => 'courses#show_years'
  get '/courses/terms/' => 'courses#show_terms'
  get '/lectures/:term/:year' => 'courses#show_lectures'
  get '/lecture_instances/:lec_id' => 'lecture_instances#get_by_lec_id'
  get '/lecture_instances/:lecture_instance_id/info' => 'lecture_instances#show'
  get '/users/roles' => 'users#show_roles'
  get '/lecture_instances/status/:lec_id' => 'lecture_instances#get_attended_lectures_by_student'
  delete '/users/avatars' => 'users#destroy_avatars'
  root to: 'courses#home'

  mount_devise_token_auth_for 'User', at: 'auth'  , controllers: {
      registrations:  'custom/registrations',
      sessions:  'custom/sessions'
    }
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
    
    resources 'attendance_issues', only: %i[index create] do
      collection do
        scope ':attendance_issue_id' do
          post 'resolve'
          post 'reject'
        end
      end
    end
  end

  # Upload Image Route
  resources :users, only: [] do
    post 'image', to: 'users#upload_image'
    collection do
      get 'statistics', to: 'users#lecturer_statistics'
      get 'courses', to: 'users#courses'
    end
  end
end
