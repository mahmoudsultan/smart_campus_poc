# frozen_string_literal: true

class ActivityLog < ApplicationRecord
  enum state: %i[empty active lecture]

  belongs_to :klass

  validates :klass, :date, :state, presence: true
end
