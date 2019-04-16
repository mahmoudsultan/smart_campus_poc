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


    # Takes a lecture_instance_id and a set of ids along with the coordinates
    # of the bounding box for each student
    # and creates the associated facebox active records and attendance sheet
    # JSON: {
    #    'lecture_instance_id': 1, 
    #    'attendances': 
    #       {
    #           '123': {'coords': [100, 200, 400, 500], 'state': 0},
    #           '456': {'coords': [500, 600, 800, 800], 'state': 1}
    #       }
    #   }
    # 
    def save
        lecture_instance_id = params[:lecture_instance_id]
        attendance_sheet = AttendanceSheet.create!({lecture_instance_id: lecture_instance_id})

        params[:attendances].each do |student_id, data|
            state = data[:state]
            coords = data[:coords]
            facebox = {user_id: student_id, boundaries: coords, state: state, attendance_sheet_id: attendance_sheet.id}
            Facebox.create!(facebox)
        end

        render json: attendance_sheet, status: :created
    end

    private

    def get_topic_name_from_class(class_id)
        'random_topic_name'
    end



end
