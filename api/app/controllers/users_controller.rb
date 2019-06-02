# frozen_string_literal: true

class UsersController < ApplicationController
  include ActionController::RequestForgeryProtection
  protect_from_forgery unless: -> {request.format.json?}
  before_action :authenticate_user!
  # load_and_authorize_resource
  before_action :set_user, only: %i[upload_image]
  before_action :user_params, only: %i[upload_image]

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { head :forbidden }
      format.js   { head :forbidden }
    end
  end

  def print_user
    print 'current user'
    puts current_user
  end

  def upload_image
    if @user.update user_params
      @user.reload
      render json: { user: { image: @user.image } }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show_roles
    roles = Ability.new(current_user).to_list
  
    puts current_user
    puts roles
    render json: {roles: roles}
  end

  private
  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def user_params
    params.require(:user).permit(%i[image])
  end
end
