# frozen_string_literal: true

require 'rails_helper'
include ActionController::RespondWith

RSpec.describe 'Avatars', type: :request do

  context 'Adding images when signing up a user' do
    let(:professor) {
        prof = attributes_for(:prof)
        avatar1 = attributes_for(:avatarJpeg)
        avatar2 = attributes_for(:avatarPng)
        prof[:avatars] = [avatar1, avatar2]
        prof[:role] = "professor"
        prof
    }
    before {
       post '/auth',  params: professor.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    }
    
    it 'returns 200' do
        expect(response).to have_http_status(200)
    end

    it 'saves the avatar' do
        res = JSON.parse(response.body)
        user = User.find(res['data']['id'].to_i)
        expect(user.avatars.count).to eq(professor[:avatars].length)
        user.avatars.each do |a| 
            expect(a.image).to_not be_nil
        end
    end

    it 'returns the avatars in the response' do
        res = JSON.parse(response.body)
        expect(res['data']['avatars'].length).to eq(professor[:avatars].length)
    end
  end

  context 'updating user images on post' do
    let(:avatars) {
        [build(:avatarJpg), build(:avatarPng)]
    }
    let(:prof) {
        user_attr = attributes_for(:prof)
        user_attr[:avatars] = avatars
        user = User.create(user_attr)  
        user
      }
    let(:headers) {
        post '/auth/sign_in', params: {email: prof.email, password: prof.password}
        response.headers.slice('access-token', 'uid', 'client', 'expiry')
    }

    
    it 'accepts the new images' do
        update_body = prof.attributes
        update_body[:avatars] = [attributes_for(:avatarJpeg)]
        put '/auth', params: update_body, headers: headers
        expect(prof.avatars.count).to eq(avatars.length + 1)
    end

    it 'rejects existing images' do
        update_body = prof.attributes
        update_body[:avatars] = [attributes_for(:avatarJpg)]
        put '/auth', params: update_body, headers: headers
        expect(prof.avatars.count).to eq(avatars.length)

    
    end

  end


  context 'returns user images' do 
  end

end
