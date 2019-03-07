# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lecture, type: :model do
  it { should validate_presence_of(:course_offering) }
  it { should validate_presence_of(:start_timeslot) }
  it { should validate_presence_of(:end_timeslot) }
  it { should validate_presence_of(:day) }

  it { should validate_inclusion_of(:start_timeslot).in_array((1..12).to_a) }
  it { should validate_inclusion_of(:end_timeslot).in_array((1..12).to_a) }
end
