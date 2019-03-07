# frozen_string_literal: true

class LectureInstance < ApplicationRecord
  belongs_to :lecture

  validates :lecture, :week_number, :date, presence: true
end
