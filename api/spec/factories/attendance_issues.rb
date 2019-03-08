# frozen_string_literal: true

FactoryBot.define do
  factory :attendance_issue do
    user { nil }
    face_box { nil }
    attendance_sheet { nil }
  end
end
