# frozen_string_literal: true

class UsersController < ApplicationController
  include ActionController::RequestForgeryProtection
  # protect_from_forgery unless: -> {request.format.json?}
  # before_action :authenticate_user!
  # load_and_authorize_resource
  before_action :set_user, only: %i[upload_image]
  before_action :user_params, only: %i[upload_image]



  def upload_image
    # puts 'in upload_image'
    # puts params
    # avatar = Avatar.create({user_id: @user.id, image: params[:image], is_main: true})
    # render json: { user: { avatars: @user.avatars } }, status: :ok
    
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

  def lecturer_statistics
    # Statistics are number of courses, number of students, and number of lectures
    # Get all groups that Lecturer is in
    @user = current_user
    groups = @user.groups
    # Get Number of Students in those groups
    number_of_students = groups.map(&:users).flatten.uniq.length - 1

    # Get Number Of Distinct Courses using Groups
    courses_codes = groups.map(&:course).map(&:code).uniq
    number_of_courses = courses_codes.length

    # Get Number Of Lectures through groups
    number_of_lectures=  groups.map(&:lectures).flatten.uniq.length

    statistics = {
      courses: number_of_courses,
      lectures: number_of_lectures,
      students: number_of_students
    }

    render json: statistics, status: :ok
  end

  def courses
    @user = current_user
    groups = @user.groups
    courses = groups.map(&:course_offering).map(&:course).uniq
    render json: {courses: courses}, status: :ok
  end

  private
  def set_user
    @user = User.find(params[:user_id||:id])
  end

  def user_params
    params.permit(:image)
  end
end
