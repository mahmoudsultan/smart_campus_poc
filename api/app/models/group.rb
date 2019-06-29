# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :course_offering
  has_many :group_users
  has_many :lectures
  has_many :users, through: :group_users

  validates :name, presence: true

  def professors
    users.select(&:professor?)
  end

  def students
    users.select(&:student?)
  end

  def course
    course_offering&.course
  end
end
