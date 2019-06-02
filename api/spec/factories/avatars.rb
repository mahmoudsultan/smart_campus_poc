FactoryBot.define do
  factory :avatar do
    image { "" }
    user { nil }
    is_main { false }
    
    factory :avatarJpeg do
      image { "data:image/jpeg;base64,#{ Base64.encode64(File.open(File.join(Rails.root, '/spec/fixtures/files/avatar.jpeg'), &:read)) }" }
    end

    factory :avatarJpg do
      image { "data:image/jpg;base64,#{ Base64.encode64(File.open(File.join(Rails.root, '/spec/fixtures/files/avatar3.jpg'), &:read)) }" }
    end
  
    factory :avatarPng do
      image { "data:image/png;base64,#{ Base64.encode64(File.open(File.join(Rails.root, '/spec/fixtures/files/avatar_placeholder.png'), &:read)) }" } 
    end
  end
end
