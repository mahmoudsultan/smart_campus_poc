# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions
  devise_token_auth_group :member, contains: %i[user admin]
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    render json: {error: 'access denied'}, status: :forbidden
  end
 

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :email, :name, :department, {avatars:[:image] }] ) 
    devise_parameter_sanitizer.permit(:account_update, keys: [:role, :email, :name, :department, {avatars:[:image, :id] }] ) 
  end
end
