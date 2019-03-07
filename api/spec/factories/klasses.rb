# frozen_string_literal: true

FactoryBot.define do
  factory :klass do
    name { 'MyString' }
    floor { 'MyString' }
    capacity { 1 }
    projector { false }
    building { nil }
  end
end
