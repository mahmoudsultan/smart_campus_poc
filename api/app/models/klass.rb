# frozen_string_literal: true

class Klass < ApplicationRecord
  belongs_to :building

  validates :name, :floor, :capacity, :building, presence: true
end
