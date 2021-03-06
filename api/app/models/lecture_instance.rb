# frozen_string_literal: true

class LectureInstance < ApplicationRecord
  belongs_to :lecture
  has_one :group, through: :lecture
  has_one :course_offering, through: :lecture
  has_one :klass, through: :lecture
  has_many :attendance_sheets

  validates :lecture, :week_number, :date, presence: true

  def course
    course_offering.course
  end
end
