# frozen_string_literal: true

class LectureInstancesController < ApplicationController
  before_action :set_lecture_instance, only: %i[place]

  def place
    render json: @lecture_instance.klass, status: :ok
  end

  private

  def set_lecture_instance
    @lecture_instance = LectureInstance.find params[:id]
  end
end
