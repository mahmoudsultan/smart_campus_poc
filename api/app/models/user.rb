# frozen_string_literal: true

class User < ApplicationRecord
  enum role: %i[professor student]

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  # before_save -> { skip_confirmation! }

  has_many :group_users
  has_many :groups, through: :group_users, foreign_key: :user_id

  validates :name, :department, presence: true
end
