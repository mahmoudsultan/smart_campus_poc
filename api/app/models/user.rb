# frozen_string_literal: true

class User < ApplicationRecord
  before_save -> { skip_confirmation! }

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, :department, presence: true
end
