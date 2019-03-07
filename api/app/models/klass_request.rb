# frozen_string_literal: true

class KlassRequest < ApplicationRecord
  enum state: %i[open closed granted]

  validates :required_capacity, presence: true
  validates :state, presence: true, inclusion: { in: states.keys }
end
