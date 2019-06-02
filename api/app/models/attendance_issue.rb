# frozen_string_literal: true

class AttendanceIssue < ApplicationRecord
  enum state: %i[pending resolved rejected]

  belongs_to :user
  belongs_to :face_box
  belongs_to :attendance_sheet
end
