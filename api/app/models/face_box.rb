# frozen_string_literal: true

class FaceBox < ApplicationRecord
  enum state: %i[recognized detected alleged]

  belongs_to :user, optional: true
  belongs_to :attendance_sheet

  validates :boundaries, presence: true
end
