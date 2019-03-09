# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourseOffering, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:term) }
    it { should validate_presence_of(:course) }
  end
end
