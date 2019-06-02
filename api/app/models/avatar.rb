class Avatar < ApplicationRecord
  belongs_to :user
  mount_base64_uploader :image, AvatarUploader, file_name: ->(a) { "#{rand(1000)}" }
end
