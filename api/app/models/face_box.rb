# frozen_string_literal: true

class FaceBox < ApplicationRecord
  enum state: %i[recognized detected alleged]

  belongs_to :user, optional: true
  belongs_to :attendance_sheet, optional: true


  validates :boundaries, presence: true

  def serializable_hash(options = nil)
    # user = user.presence # if the relation doesn't have user_id in the
                         # selection user doesn't exist and is not even nil
    puts self.state
    puts self.attributes
    super(options).merge(
      student_id: self.user&.student_id
    )
  end
end
