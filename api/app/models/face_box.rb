# frozen_string_literal: true

class FaceBox < ApplicationRecord
  enum state: %i[recognized detected alleged]

  belongs_to :user, optional: true
  belongs_to :attendance_sheet

  validates :boundaries, presence: true

  def serializable_hash(options = nil)
    super(options).merge(
      student_id: user&.student_id
    )
  end
end
