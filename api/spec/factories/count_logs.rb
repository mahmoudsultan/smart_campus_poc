# frozen_string_literal: true

FactoryBot.define do
  factory :count_log do
    date { '2019-03-07 15:03:44' }
    count { 1 }
    klass { nil }
  end
end
