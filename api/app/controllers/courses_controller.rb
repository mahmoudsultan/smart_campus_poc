class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:home]
  load_and_authorize_resource


  def show_lectures
    CourseOffering.connection
    Building.connection

    role = current_user.role
    uid = request.headers[:uid]
    
    q = CourseOffering.joins({ lectures: {klass: :building} }, :course, groups: { group_users: :user } )
    .where(users: { uid: request.headers[:uid] },
      course_offerings: { term: params[:term], year: params[:year] })
      .select('users.id as user_id', 'users.name as user_name','courses.code',
              'courses.title','lectures.day', 'lectures.start_timeslot',
              'lectures.end_timeslot','buildings.name as building_name',
              'klasses.name as klass_name','klasses.floor','klasses.capacity',
              'lectures.id as lec_id')

    render json: q
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

# CourseOffering.joins({ lectures: {klass: :building} }, :course, groups: { group_users: :user } ).where(users: { id: 57 },course_offerings: { term: params[:term], year: params[:year] }).select('users.id as user_id','courses.code','lectures.id as lec_id')
