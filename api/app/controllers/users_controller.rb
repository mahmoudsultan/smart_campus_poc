# frozen_string_literal: true

class UsersController < ApplicationController
  include ActionController::RequestForgeryProtection
  protect_from_forgery unless: -> {request.format.json?}
  before_action :authenticate_user!
  before_action :set_user, only: %i[upload_image]
  before_action :user_params, only: %i[upload_image]

  def upload_image
    if @user.update user_params
      @user.reload
      render json: { user: { image: @user.image } }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def user_params
    params.require(:user).permit(%i[image])
  end
end
