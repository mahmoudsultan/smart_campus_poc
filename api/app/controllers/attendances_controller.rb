# frozen_string_literal: true

class AttendancesController < ApplicationController
  before_action :set_lecture_instance, only: %i[new save update]
  before_action :set_attendance_sheet, only: %i[update]

  # Takes lecture_instance_id and an optional class_id
  # Gets a frame from the corresponding class
  # Gets list of students registered in the course
  # Sends the frame along with the students' ids to the attendance service
  # Retuns a JSON containing found students with the corresponding bounding box
  # coordinates
  def new
    # 1. Get Frame from Kafka (encoded in base64)
    frame_encoded = Kafka::GetAttendanceFrameService.new(topic_name).execute
    frame_encoded_base64 = 'data:image/jpeg;base64,' + frame_encoded
    # 2. Send Frame to Attendance MicroService along with group students
    group_students = @lecture_instance.group.students.pluck(:student_id)
    params = { image: frame_encoded, ids: group_students }
    results = Attendance::GetAttendanceService.new(params).execute

    face_boxes = JSON.parse(JSON.parse(results.body))['face_boxes']
    face_boxes.each do |face_box|
      face_box['boundaries'] = face_box['boundaries'].join(',')
    end

    # 3. Return Frame and the Returned Face Boxes
    render json: { image: frame_encoded_base64, face_boxes: face_boxes }, status: :ok
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
  def save
    attendance_sheet = AttendanceSheet.create! lecture_instance: @lecture_instance, image: params[:image]

    # params[:face_boxes].each do |face_box|
    #   state = face_box[:student_id].nil? ? :detected : :recognized

    #   user = nil
    #   user = User.find_by student_id: face_box[:student_id] if face_box[:student_id]

    #   facebox = { user: user, state: state,
    #               boundaries: face_box[:boundaries], attendance_sheet_id: attendance_sheet.id }
    #   FaceBox.create!(facebox)
    # end
    create_face_boxes(attendance_sheet, params[:face_boxes])

    render json: attendance_sheet, status: :created
  end

  def update
    @attendance_sheet.transaction do
      create_face_boxes(@attendance_sheet, params[:new_face_boxes])

      update_face_boxes(@attendance_sheet, params[:edited_face_boxes])

      params[:deleted_face_boxes].each do |deleted_face_box|
        FaceBox.delete deleted_face_box[:id]
      end
    end

    render json: @attendance_sheet, status: :ok
  end

  private

  def set_lecture_instance
    @lecture_instance = LectureInstance.find(params[:id] || params[:lecture_instance_id])
  end

  def set_attendance_sheet
    @attendance_sheet = @lecture_instance.attendance_sheets.last
  end

  def get_topic_name_from_class(class_id)
    Klass.find(class_id).topic_name
  end

  def klass_id_from_lecture_instance
    @lecture_instance.lecture.klass.id
  end

  def topic_name
    klass_id = params[:class_id] || klass_id_from_lecture_instance
    get_topic_name_from_class(klass_id)
  end

  def create_face_boxes(attendance_sheet, face_boxes)
    face_boxes.each do |face_box|
      state = face_box[:student_id].nil? ? :detected : :recognized

      user = nil
      user = User.find_by student_id: face_box[:student_id] if face_box[:student_id]

      facebox = { user: user, state: state,
                  boundaries: face_box[:boundaries], attendance_sheet_id: attendance_sheet.id }
      FaceBox.create!(facebox)
    end
  end

  def update_face_boxes(_attendance_sheet, face_boxes)
    face_boxes.each do |face_box|
      face_box_record = FaceBox.find face_box[:id]

      state = face_box[:student_id].nil? ? :detected : :recognized

      user = nil
      user = User.find_by student_id: face_box[:student_id] if face_box[:student_id]

      facebox = { user: user, state: state,
                  boundaries: face_box[:boundaries] }
      face_box_record.update facebox
    end
  end
end
