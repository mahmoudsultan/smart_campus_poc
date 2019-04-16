class AttendancesController < ApplicationController

    def get
        results = Attendance::GetAttendanceService.new(params).execute
        render json: results.body
    end


    # Takes lecture_instance_id and an optional class_id
    # Gets a frame from the corresponding class
    # Gets list of students registered in the course
    # Sends the frame along with the students' ids to the attendance service
    # Retuns a JSON containing found students with the corresponding bounding box
    # coordinates
    def get_attendance
        if params[:class_id].nil?
            @topic_name = get_topic_name_from_class(params[:class_id])
        else
            ret_val = LectureInstance.select('lecture_instances.id as id, lectures.klass_id as klass_id, lectures.group_id as group_id, lectures.id as lecture_id, course_offerings.id as course_offering_id')
                                    .joins(:lecture => [:group => :course_offering])
                                    .find(params[:lecture_instance_id])
                                    
            @klass_id = ret_val.klass_id
            @group_id = ret_val.group_id
            @course_offering_id = ret_val.course_offering_id
            @lecture_id = ret_val.lecture_id

            @topic_name = get_topic_name_from_class(@klass_id)
        end

        @frame = Kafka::GetAttendanceFrameService.new(@topic_name).execute
        @frame_encoded = Base64.encode64(@frame)

        @registered_students = GroupUser.select('users.id as user_id')
                            .joins(:user)
                            .where("group_id = ?", @group_id)

        @students_ids = []
        @registered_students.each do |student|
            @students_ids.push(student.user_id)
        end
        
        params = {image: @frame_encoded, ids: @students_ids}
        results = Attendance::GetAttendanceService.new(params).execute

        render json: results.body, status: :ok
    end


    # Takes a set of IDs along with facebox coordinates
    # and creates the associated facebox active records and attendances heet
    # currently assumes it received a JSON keyed using id and
    # the value is the coordinates of the facebox (state is assumed to be `recognized`)
    def save
        # TODO
        # Create AttendaceSheet object
        # Modify to get state from the sent data

        params[:face_boxes].each do |student_id, facebox_coords|
            facebox = {user_id: student_id, boundaries: facebox_coords, state: 0}
            Facebox.create!(facebox)
        end
    end

    private

    def get_topic_name_from_class(class_id)
        'random_topic_name'
    end



end
