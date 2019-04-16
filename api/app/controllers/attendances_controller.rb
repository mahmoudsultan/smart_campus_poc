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
            @ret_val = LectureInstance.pluck('klass_id, group_id, course_offering_id')
                            .joins(:lecture)
                            .find_by('id' => params[:lecture_instance_id]))
            
            @klass_id = @ret_val[0]
            @group_id = @ret_val[1]
            @course_offering_id = @ret_val[2]

            @topic_name = get_topic_name_from_class(@klass_id)
        end

        @frame = Kafka::GetAttendanceFrameService.new(@topic_name).execute



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
