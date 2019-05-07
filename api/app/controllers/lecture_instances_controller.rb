# frozen_string_literal: true

class LectureInstancesController < ApplicationController
  before_action :set_lecture_instance, only: %i[place students attendance_sheet]

  def place
    render json: @lecture_instance.klass, status: :ok
  end

  def students
    students = @lecture_instance.course_offering.groups.map(&:students).flatten
    render json: students, status: :ok
  end

  def attendance_sheet
    attendance_sheet = @lecture_instance.attendance_sheets.includes(:face_boxes).last
    render json: attendance_sheet, include: %i[face_boxes], methods: %i[image], status: :ok
  end

  private

  def set_lecture_instance
    @lecture_instance = LectureInstance.find(params[:id] || params[:lecture_instance_id])
  end
end
