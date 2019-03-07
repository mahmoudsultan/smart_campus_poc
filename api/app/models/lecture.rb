# frozen_string_literal: true

class Lecture < ApplicationRecord
  enum day: %i[saturday sunday monday tuesday wednesday thrusday friday]

  belongs_to :course_offering

  validates :day, :start_timeslot, :end_timeslot, :course_offering, presence: true
  validates :start_timeslot, :end_timeslot, inclusion: { in: (1..12).to_a }
end
