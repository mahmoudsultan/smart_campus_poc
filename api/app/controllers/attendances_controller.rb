# frozen_string_literal: true

class AttendancesController < ApplicationController
  before_action :set_lecture_instance, only: [:get_attendance]

  # def get
  #   results = Attendance::GetAttendanceService.new(params).execute
  #   render json: results.body
  # end

  # Takes lecture_instance_id and an optional class_id
  # Gets a frame from the corresponding class
  # Gets list of students registered in the course
  # Sends the frame along with the students' ids to the attendance service
  # Retuns a JSON containing found students with the corresponding bounding box
  # coordinates
  def new
    # 1. Get Frame from Kafka (encoded in base64)
    frame_encoded = Kafka::GetAttendanceFrameService.new(topic_name).execute

    # 2. Send Frame to Attendance MicroService along with group students
    group_students = @lecture_instance.group.students.pluck(:student_id)
    params = { image: frame_encoded, ids: group_students }
    results = Attendance::GetAttendanceService.new(params).execute

    # 3. Return Frame and the Returned Face Boxes
    render json: { frame: frame_encoded, face_boxes: results.body }, status: :ok
  end

  # Takes a lecture_instance_id and a set of ids along with the coordinates
  # of the bounding box for each student
  # and creates the associated facebox active records and attendance sheet
  # JSON: {
  #    'lecture_instance_id': 1,
  #    'attendances':
  #       {
  #           '123': {'coords': [100, 200, 400, 500], 'state': 0},
  #           '456': {'coords': [500, 600, 800, 800], 'state': 1}
  #       }
  #   }
  #
  def save
    lecture_instance_id = params[:lecture_instance_id]
    attendance_sheet = AttendanceSheet.create!(lecture_instance_id: lecture_instance_id)

    params[:attendances].each do |student_id, data|
      state = data[:state]
      coords = data[:coords]
      facebox = { user_id: student_id, boundaries: coords, state: state, attendance_sheet_id: attendance_sheet.id }
      Facebox.create!(facebox)
    end

    render json: attendance_sheet, status: :created
  end

  private

  def set_lecture_instance
    @lecture_instance = LectureInstance.find params[:lecture_instance_id]
  end

  def get_topic_name_from_class(_class_id)
    'random_topic_name'
  end

  def klass_id_from_lecture_instance
    @lecture_instance.lecture.klass.id
  end

  def topic_name
    klass_id = params[:class_id] || klass_id_from_lecture_instance
    get_topic_name_from_class(klass_id)
  end
end
