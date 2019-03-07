# frozen_string_literal: true

FactoryBot.define do
  factory :klass_request do
    trait :valid do
      required_capacity { 30 }
      projector { true }
      state { 0 }
    end
  end
end
