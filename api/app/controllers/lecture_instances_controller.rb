class LectureInstancesController < ApplicationController
    def get_by_lec_id
        lecture_instances = LectureInstance.where(lecture: params[:lec_id])
        .select(%i[id date week_number])
        render json: lecture_instances , status: :ok
    end
    
    def get_attended_lectures_by_student

        result = FaceBox.joins({attendance_sheet: :lecture_instance},:user)
               .where(lecture_instances: {lecture_id: params[:lec_id]}, 
               users: {uid: request.headers[:uid]}).select(:state, 'lecture_instances.id')
    
        render json: result, status: :ok
    end
end

