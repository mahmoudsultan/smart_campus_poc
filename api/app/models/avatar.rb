class Avatar < ApplicationRecord
  belongs_to :user
  mount_base64_uploader :avatar, AvatarUploader, file_name: ->(a) { "#{a.user.id}-#{a.id}" }

end
