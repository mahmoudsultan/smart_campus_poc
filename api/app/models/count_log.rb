# frozen_string_literal: true

class CountLog < ApplicationRecord
  belongs_to :klass

  validates :klass, :date, :count, presence: true
end
