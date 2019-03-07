# frozen_string_literal: true

class KlassRequest < ApplicationRecord
  belongs_to :klass

  enum state: %i[open closed granted]

  validates :required_capacity, presence: true
  validates :state, presence: true, inclusion: { in: states.keys }
  validates :klass, presence: true, if: -> { granted? }
end
