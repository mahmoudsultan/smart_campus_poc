class CoursesController < ApplicationController
  def show_lectures
    CourseOffering.connection
    Building.connection
    @q = CourseOffering

    @q = CourseOffering.joins({ lectures: {klass: :building} }, :course, groups: { group_users: :user } ).where(users: { uid: request.headers[:uid] },
      course_offerings: { term: params[:term], year: params[:year] })
      .select('users.id as user_id', 'users.name as user_name','courses.code',
              'courses.title','lectures.day', 'lectures.start_timeslot',
              'lectures.end_timeslot','buildings.name as building_name',
              'klasses.name as klass_name','klasses.floor','klasses.capacity',
              'lectures.id as lec_id')

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

end