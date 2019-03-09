# frozen_string_literal: true

FactoryBot.define do
  factory :lecture do
    start_timeslot { 1 }
    end_timeslot { 1 }
    day { 1 }
    CourseOffering { nil }
  end
end
