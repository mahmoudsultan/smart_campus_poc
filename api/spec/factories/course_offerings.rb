# frozen_string_literal: true

FactoryBot.define do
  factory :course_offering do
    term { 1 }
    year { 1 }
    association :course, factory: %i[course]
  end
end
