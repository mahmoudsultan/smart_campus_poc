# frozen_string_literal: true

class LectureInstancesController < ApplicationController
  before_action :set_lecture_instance, only: %i[show place students attendance_sheet]
  before_action :set_lecture, only: %i[get_by_lec_id]
  before_action :authenticate_user!

  def show
    render json: @lecture_instance, status: :ok
  end

  def place
    render json: @lecture_instance.klass, status: :ok
  end

  def students
    students = @lecture_instance.course_offering.groups.map(&:students).flatten
    render json: students, status: :ok
  end

  def attendance_sheet
    attendance_sheet = @lecture_instance.attendance_sheets.eager_load(:face_boxes, issues: :face_box).last
    render json: attendance_sheet, include: {face_boxes: {}, issues: {include: :face_box}}, methods: %i[image_base64], status: :ok
  end

  def get_by_lec_id
    if current_user.role == 'professor'
        lecture_instances = LectureInstance.where(lecture: params[:lec_id])
                            .select(%i[id date week_number])
    elsif current_user.role == 'student'
        puts 'student'
        # user_lecture_instances = current_user.face_boxes.map(&:lecture_instance).pluck(:id)
        lecture_instances = @lecture.lecture_instances
        lecture_instances = lecture_instances.map(&:attributes).each do |lecture_instance|
          puts lecture_instance
          attendance_sheet = AttendanceSheet.where(lecture_instance_id: lecture_instance["id"]).last
          if attendance_sheet
            lecture_instance[:state] = FaceBox.where(user: current_user, attendance_sheet_id: attendance_sheet.id).last&.state&.capitalize || 'Not Detected'
            puts lecture_instance[:state]
          else
            lecture_instance[:state] = "No Attendance Taken"
          end
          lecture_instance
        end
        # lecture_instances = FaceBox.joins({attendance_sheet: :lecture_instance},:user)
        #                 .where(lecture_instances: {lecture_id: params[:lec_id]}, 
        #                 users: {uid: request.headers[:uid]})
        #                 .select(:state, 'lecture_instances.id', 'lecture_instances.id',
        #                         'lecture_instances.date', 'lecture_instances.week_number', 'face_boxes.user_id')
    
    end

    puts lecture_instances.as_json
    render json: lecture_instances , status: :ok
  end

  def get_attended_lectures_by_student

    result = FaceBox.joins({attendance_sheet: :lecture_instance},:user)
           .where(lecture_instances: {lecture_id: params[:lec_id]}, 
           users: {uid: request.headers[:uid]}).select(:state, 'lecture_instances.id')

    render json: result, status: :ok
  end

  private
  def set_lecture
    @lecture = Lecture.find(params[:lec_id])
  end


  def set_lecture_instance
    @lecture_instance = LectureInstance.find(params[:id] || params[:lecture_instance_id])
  end
end

