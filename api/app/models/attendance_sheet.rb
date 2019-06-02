# frozen_string_literal: true

class AttendanceSheet < ApplicationRecord
  belongs_to :lecture_instance
  has_many :face_boxes
  has_many :issues, class_name: "AttendanceIssue"

  mount_base64_uploader :image, ImageUploader, file_name: ->(u) { "#{u.lecture_instance.id}-#{u.id}" }

  def image_base64
    image_file = File.open(File.join(Rails.root, 'public', self.image.url), 'rb')
    'data:image/jpeg;base64,' + Base64.strict_encode64(image_file.read)
  end
end
