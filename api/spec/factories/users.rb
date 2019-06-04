# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    department { 'CCE' }
    password { '123456789' }
    sequence(:email) { |n| "not.john.doe#{n}@gmail.com" }

    trait :professor do
      role { :professor }
    end

    trait :student do
      sequence(:student_id) { |n| n.to_s * 4 }
      role { :student }
    end
    factory :prof,  traits: [:professor]
  end
end
