# frozen_string_literal: true

class AttendanceSheet < ApplicationRecord
  belongs_to :lecture_instance
  has_many :face_boxes
  has_many :issues, class_name: "AttendanceIssue"

  mount_base64_uploader :image, ImageUploader, file_name: ->(u) { "#{u.lecture_instance.id}-#{u.id}" }
end
