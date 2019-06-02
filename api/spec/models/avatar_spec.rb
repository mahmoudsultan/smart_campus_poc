require 'rails_helper'
require 'fileutils'

RSpec.describe Avatar, type: :model do
  let (:user) {
    user = create(:user)
    avatar1 = attributes_for(:avatarJpeg)
    avatar2 = attributes_for(:avatarPng)
    
    user.avatars.create!(avatar1)
    user.avatars.create!(avatar2)
    user
  }
  after {
    paths = user.avatars.map { |a| "/api/uploads/avatar/image/#{a.image}" }    
    paths.each {|path| FileUtils.rm_rf(path)}
  }

  context 'created directly' do
    it 'should be saved' do
     
      expect(user.avatars.count).to eq(2)
    end


  
  end

  context "create avatar through a user" do
    let(:user) {
      user_attr = attributes_for(:user)
      avatar = build(:avatarJpg)
      user_attr[:avatars] = [avatar]
      user = User.create(user_attr)  
      user
    }

    after {
      paths = user.avatars.map { |a| "#{a.image}" }    
      paths.each { |path| FileUtils.rm_rf(path)}
    }

    it 'should exist in avatars table' do

      expect(user.avatars.count).to eq(1)
    end

    it 'should have a non null image' do 
      expect(user.avatars.pluck(:id)).to_not be_nil  
    
    
    end

  end

end
