# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  devise_token_auth_group :member, contains: %i[user admin]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit the `subscribe_newsletter` parameter along with the other
    # sign up parameters.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :department])
  end
end
