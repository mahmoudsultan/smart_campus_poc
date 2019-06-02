class AttendanceIssuesController < ApplicationController
  before_action :set_lecture_instance, only: %i[index create]
  before_action :set_attendance_sheet, only: %i[index create]
  before_action :set_student, only: %i[index create]
  before_action :set_issue, only: %i[resolve reject]

  def index
    student_issue = @attendance_sheet.issues.where(user: @student)
    render json: student_issue, methods: %i[state]
  end

  def create
    issue = nil
    @attendance_sheet.transaction do
      face_box = params[:face_box]

      facebox_params = { user: @student, state: :alleged,
                         boundaries: face_box[:boundaries] }
      
      
      face_box = FaceBox.create!(facebox_params)
      
      issue = @attendance_sheet.issues.create! user: @student, face_box: face_box
      render json: issue, status: :created
    rescue Exception
      render json: issue&.errors, status: :unprocessible_entity
    end
  end

  def resolve
    unless @issue.pending?
      render json: { errors: 'Only pending Issues can be resolved.' }, status: :unprocessible_entity
    else
      AttendanceIssue.transaction do
        @issue.attendance_sheet.face_boxes << @issue.face_box
        @issue.face_box.recognized!
        @issue.resolved!
      end

      render json: @issue, status: :ok
    end
  end

  def reject
    unless @issue.pending?
      render json: { errors: 'Only pending Issues can be rejected.' }, status: :unprocessible_entity
    else
      @issue.rejected!
      render json: @issue, status: :ok
    end
  end

  private

  def set_lecture_instance
    @lecture_instance = LectureInstance.find(params[:id] || params[:lecture_instance_id])
  end

  def set_attendance_sheet
    @attendance_sheet = @lecture_instance.attendance_sheets.last
  end

  def set_student
    # TODO: Set user using current_user
    @student = User.find 4
  end

  def set_issue
    @issue = AttendanceIssue.find params[:attendance_issue_id]
  end
end
