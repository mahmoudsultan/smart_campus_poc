# frozen_string_literal: true

class Course < ApplicationRecord
  before_validation -> { code.upcase! unless code.nil? }

  validates :code, presence: true, uniqueness: true
  validates :title, presence: true
end
