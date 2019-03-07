# frozen_string_literal: true

FactoryBot.define do
  factory :klass_request do
    required_capacity { 1 }
    projector { false }
    state { 1 }
  end
end
