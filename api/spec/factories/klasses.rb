# frozen_string_literal: true

FactoryBot.define do
  factory :klass do
    name { 'C11' }
    floor { 'first' }
    capacity { 30 }
    projector { true }
    trait :ssp do
      association :building, factory: %i[building ssp]
    end
  end
end
