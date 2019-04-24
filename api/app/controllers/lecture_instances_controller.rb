class LectureInstancesController < ApplicationController
    def get_by_lec_id
        lecture_instances = LectureInstance.where(lecture: params[:lec_id])
        .select(%i[id date week_number])
        render json: lecture_instances , status: :ok
    end
end
