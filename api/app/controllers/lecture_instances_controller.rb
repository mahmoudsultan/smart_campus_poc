class LectureInstancesController < ApplicationController
    before_action :set_lecture_instance, only: %i[place]
    def place
        place = @lecture_instance.klass.name

        render json: { place: place }, status: :ok
    end

    private
    def set_lecture_instance
        @lecture_instance = LectureInstance.find params[:id]
    end

end