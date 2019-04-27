# frozen_string_literal: true

class AttendanceIssue < ApplicationRecord
  belongs_to :user
  belongs_to :face_box
  belongs_to :attendance_sheet
end
