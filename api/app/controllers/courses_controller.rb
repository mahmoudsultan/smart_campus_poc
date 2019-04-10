class CoursesController < ApplicationController
  def show_lectures
    # respond_to do |format|
    #   format.json do
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
            " AND `course_offerings`.`year`=?", params[:pid], params[:term], params[:year]
          ).select('users.name as user_name,courses.code,courses.title,lectures.day,lectures.start_timeslot,lectures.end_timeslot,'\
            'buildings.name as building_name,klasses.name as klass_name,klasses.floor,klasses.capacity')

        render json: @q

        # @q = @q.joins('INNER JOIN users ON users.id = group_users.user_id')
        # @q = @q.joins('INNER JOIN courses ON courses.id = course_offerings.course_id INNER JOIN groups ON groups.course_offering_id = course_offerings.id INNER JOIN group_users ON group_users.group_id = groups.id')
        # @q = @q.select('users.')
        # @q = @q.where('users.id = ?', params[:pid])
        # @q = @q.where('course_offerings.term = ?', params[:term])
        # @q = @q.where('course_offerings.year = ?', params[:year])

        # courses = CourseOffering.joins(:course).where(:term=>params[:term], :year=>params[:year])
        # groups = courses.joins(:groups)
        # group_users = GroupUser.joins(groups)
        # groups_of_prof = group_users.joins(:users).where(users: {user_id: params[:pid]})
        # lectrures_info = groups_of_prof.joins(lectures: :Klass)
  end
# end
# end
end
