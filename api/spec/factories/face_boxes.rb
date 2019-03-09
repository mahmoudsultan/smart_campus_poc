# frozen_string_literal: true

FactoryBot.define do
  factory :face_box do
    state { 1 }
    boundaries { 'MyString' }
    student { nil }
    attendance_sheet { nil }
  end
end
