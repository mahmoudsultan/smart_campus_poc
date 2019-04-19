class LectureInstancesController < ApplicationController
    before_action :set_lecture_instance, only: %i[place]
    def place
        place = @lecture_instance.klass.pluck(:name)

        render json: { place: place }, status: :ok
    end

    def set_lecture_instance
        @lecture_instance = LectureInstance.find params[:lecture_instance_id]
    end

end