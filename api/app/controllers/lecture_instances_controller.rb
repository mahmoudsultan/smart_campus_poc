class LectureInstancesController < ApplicationController
    before_action :authenticate_user!
    
    def get_by_lec_id
        puts 'adsdsa'
        puts current_user.role
        if current_user.role == 'professor'
            lecture_instances = LectureInstance.where(lecture: params[:lec_id])
                                .select(%i[id date week_number])
        elsif current_user.role == 'student'
            lecture_instances = FaceBox.joins({attendance_sheet: :lecture_instance},:user)
                            .where(lecture_instances: {lecture_id: params[:lec_id]}, 
                            users: {uid: request.headers[:uid]})
                            .select(:state, 'lecture_instances.id', 'lecture_instances.id',
                                    'lecture_instances.date', 'lecture_instances.week_number')
        
        end
        render json: lecture_instances , status: :ok
    end
    
    def get_attended_lectures_by_student

        result = FaceBox.joins({attendance_sheet: :lecture_instance},:user)
               .where(lecture_instances: {lecture_id: params[:lec_id]}, 
               users: {uid: request.headers[:uid]}).select(:state, 'lecture_instances.id')
    
        render json: result, status: :ok
    end
end

