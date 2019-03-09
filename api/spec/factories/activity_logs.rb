# frozen_string_literal: true

FactoryBot.define do
  factory :activity_log do
    date { '2019-03-07 15:06:41' }
    state { 1 }
    klass { nil }
  end
end
