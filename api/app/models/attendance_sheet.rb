# frozen_string_literal: true

class AttendanceSheet < ApplicationRecord
  belongs_to :lecture_instance
end
