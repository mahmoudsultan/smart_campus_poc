# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LectureInstance, type: :model do
  it { should validate_presence_of(:week_number) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:lecture) }
end
