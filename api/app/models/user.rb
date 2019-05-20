# frozen_string_literal: true

class User < ApplicationRecord
  enum role: [:professor, :student]

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  # before_save -> { skip_confirmation! }

  mount_base64_uploader :image, ImageUploader, file_name: ->(u) { "#{u.id}-#{u.name}" }

  has_many :group_users
  has_many :groups, through: :group_users, foreign_key: :user_id
  has_many :face_boxes

  validates :name, :department, presence: true
  validates :student_id, presence: true, if: :student?
end
