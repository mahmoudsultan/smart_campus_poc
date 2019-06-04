# frozen_string_literal: true

class UsersController < ApplicationController
  include ActionController::RequestForgeryProtection
  # protect_from_forgery unless: -> {request.format.json?}
  before_action :authenticate_user!
  # load_and_authorize_resource
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

  def show_roles
    roles = Ability.new(current_user).to_list
    render json: {roles: roles}
  end

  def destroy_avatars
    deletedIds = []


    avatars = Avatar.where(id: user_params[:avatars].uniq)
    avatars.each do |a| 
      a.destroy
      deletedIds << a.id
    end
    render json: {ids: deletedIds }, status: :ok
  rescue => e
    render json: {message: e.message}, status: :unprocessable_entity
  end


  private


  def user_params
    puts params
    params.permit(avatars: [])
  end
end
