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
end
