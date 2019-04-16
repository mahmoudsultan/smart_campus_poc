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

        # @student_ids = insert_query_here

        # TODO
        # Get list of registered students in the course_offering
        # Send the @frame_encoded with the retrieved ids to the attendance service 

        params = {image: @frame_encoded, ids: @student_ids}
        results = Attendance::GetAttendanceService.new(params).execute

        render json: results.body, status: :ok
    end


    # Takes a set of IDs along with facebox coordinates
    # and creates the associated active records
    def save

    end

    private

    def get_topic_name_from_class(class_id)
        'random_topic_name'
    end



end
