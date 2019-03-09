# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    let(:course_attributes) { FactoryBot.attributes_for :course, code: 'cc176' }

    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:title) }

    it 'upcase course code before uniqueness validation' do
      FactoryBot.create :course, code: 'CC176'

      expect { Course.create! course_attributes }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
