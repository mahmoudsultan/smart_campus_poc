class CoursesController < ApplicationController
  def show_lectures
    respond_to do |format|
      format.json do 
        courses = Course.joins(:courseoffering).where(courseoffering: {term: params[:term], year: params[:year]})
        groups = courses.joins(:groups)
        groups_of_prof = groups.joins(:users).where(users: {user_id: params[:pid]})
        lectrures_info = groups_of_prof.joins(lectures: :Klass)
  end
end
