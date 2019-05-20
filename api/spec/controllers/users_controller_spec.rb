# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'Image Upload' do
    let(:student) { FactoryBot.create :user, :student }
    let(:image_data) { Base64.encode64(File.open(File.join(Rails.root, '/spec/support/files/avatar.jpg'), &:read)) }
    let(:image) { "data:image/gif;base64,#{image_data}" }

    context 'with valid image' do
      let(:params) { { user: { image: image }, user_id: student.id } }

      before do
        post :upload_image, params: params
      end

      it 'uploads and sets user image' do
        expect(JSON.parse(response.body)['user']['image']['url']).not_to be_empty
      end
    end
  end
end
