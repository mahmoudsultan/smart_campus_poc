# frozen_string_literal: true

class Building < ApplicationRecord
  has_many :klasses

  validates :name, presence: true
end
