# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'professor and student associations' do
    let(:course_offering) { FactoryBot.create :course_offering }
    let!(:group) { FactoryBot.create :group }
    let!(:professor) { FactoryBot.create :user, :professor }
    let!(:student) { FactoryBot.create :user, :student }

    before do
      professor.groups << group
      student.groups << group
    end

    it 'has a professor association' do
      # expect(group.users.length).to eql 1
      expect(group.professors.length).to eql 1
    end

    it 'has a student association' do
      expect(group.students.length).to eql 1
    end
  end
end
