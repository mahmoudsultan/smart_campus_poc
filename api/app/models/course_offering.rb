# frozen_string_literal: true

class CourseOffering < ApplicationRecord
  belongs_to :course

  enum term: %i[fall spring summer]

  validates :course, presence: true
  validates :term, presence: true, inclusion: { in: terms.keys }
  validates :year, presence: true
end