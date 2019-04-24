# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  devise_token_auth_group :member, contains: %i[user admin]
end
