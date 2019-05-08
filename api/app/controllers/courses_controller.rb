class CoursesController < ApplicationController
  
  before_action :print_user
  before_action :authenticate_user!, except: [:home]
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { head :forbidden }
      format.js   { head :forbidden }
    end
  end


  def print_user
    puts current_user
  
  end

  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end

  def show_lectures
    CourseOffering.connection
    Building.connection
    @q = CourseOffering

    @q = @q.joins("INNER JOIN `courses` ON `courses`.`id` = `course_offerings`.`course_id` "\
      "INNER JOIN `groups` ON `groups`.`course_offering_id` = `course_offerings`.`id` "\
      "INNER JOIN `group_users` ON `group_users`.`group_id` = `groups`.`id`"\
      "INNER JOIN `users` ON `users`.`id` = `group_users`.`user_id`"\
      "INNER JOIN `lectures` ON `lectures`.`course_offering_id` = `course_offerings`.`id`"\
      "INNER JOIN `klasses` ON `klasses`.`id` = `lectures`.`klass_id`"\
      "INNER JOIN `buildings` ON `buildings`.`id` = `klasses`.`building_id`").where(
        "`users`.`id`=? AND `users`.`role`='professor' AND `course_offerings`.`term`=? "\
        " AND `course_offerings`.`year`=?", params[:email], params[:term], params[:year]
      ).select('users.name as user_name,courses.code,courses.title,lectures.day,lectures.start_timeslot,lectures.end_timeslot,'\
        'buildings.name as building_name,klasses.name as klass_name,klasses.floor,klasses.capacity')

    render json: @q
  end

  def show_years 
    years = CourseOffering.distinct.pluck(:year)
    render json: years
  end

  def show_terms
    terms = CourseOffering.distinct.pluck(:term)
    render json: terms
  end

  def home
    render json: {}
  end
end




# SELECT distinct users.id FROM `course_offerings` 
# INNER JOIN `courses` ON `courses`.`id` = `course_offerings`.`course_id` 
# INNER JOIN `groups` ON `groups`.`course_offering_id` = `course_offerings`.`id` 
# INNER JOIN `group_users` ON `group_users`.`group_id` = `groups`.`id`
# INNER JOIN `users` ON `users`.`id` = `group_users`.`user_id` 
# INNER JOIN `lectures` ON `lectures`.`course_offering_id` = `course_offerings`.`id` 
# INNER JOIN `klasses` ON `klasses`.`id` = `lectures`.`klass_id` 
# INNER JOIN `buildings` ON `buildings`.`id` = `klasses`.`building_id` 
# WHERE (`users`.`role`='professor' 
# AND `course_offerings`.`term`='fall'  AND `course_offerings`.`year`='2018');