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
      role { :student }
    end
  end
end
