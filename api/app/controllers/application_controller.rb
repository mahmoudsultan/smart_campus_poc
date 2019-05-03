# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions
  devise_token_auth_group :member, contains: %i[user admin]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # def abilities 
  #   rules = {rules: Ability.new(current_user).to_list} if user_signed_in? else {rules:[]}
  #   render json: rules
  # end

  protected

  def configure_permitted_parameters
    # Permit the required fields not only the email
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :department, :role])
  end
end
