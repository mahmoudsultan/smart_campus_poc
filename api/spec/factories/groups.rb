# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    name { 'MyString' }
    association :course_offering, factory: %i[course_offering]
  end
end
