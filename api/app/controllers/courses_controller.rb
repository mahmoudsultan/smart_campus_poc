class CoursesController < ApplicationController
  def show_lectures
    CourseOffering.connection
    Building.connection
    @q = CourseOffering

    @role = User.where(id: params[:id]).select(:role)

    @q = @q.joins("INNER JOIN `courses` ON `courses`.`id` = `course_offerings`.`course_id` "\
      "INNER JOIN `groups` ON `groups`.`course_offering_id` = `course_offerings`.`id` "\
      "INNER JOIN `group_users` ON `group_users`.`group_id` = `groups`.`id`"\
      "INNER JOIN `users` ON `users`.`id` = `group_users`.`user_id`"\
      "INNER JOIN `lectures` ON `lectures`.`course_offering_id` = `course_offerings`.`id`"\
      "INNER JOIN `klasses` ON `klasses`.`id` = `lectures`.`klass_id`"\
      "INNER JOIN `buildings` ON `buildings`.`id` = `klasses`.`building_id`").where(
        "`users`.`id`=? AND `users`.`role`=(?) AND `course_offerings`.`term`=? "\
        " AND `course_offerings`.`year`=?", params[:id], @role, params[:term], params[:year]
      ).select('users.id as user_id, users.name as user_name,courses.code,courses.title,lectures.day,'\
               'lectures.start_timeslot,lectures.end_timeslot,'\
               'buildings.name as building_name,klasses.name as klass_name,klasses.floor,klasses.capacity,'\
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