# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LectureInstance, type: :model do
  it { should validate_presence_of(:week_number) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:lecture) }

  it 'has a group through lecture' do
    assc = described_class.reflect_on_association(:group)
    expect(assc.macro).to eq :has_one
  end

  it 'has a course offering through lecture' do
    assc = described_class.reflect_on_association(:course_offering)
    expect(assc.macro).to eq :has_one
  end
end
