# frozen_string_literal: true

FactoryBot.define do
  factory :lecture_instance do
    week_number { 1 }
    date { '2019-03-07 16:38:24' }
    lecture { nil }
  end
end
