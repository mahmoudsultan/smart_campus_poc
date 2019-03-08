# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaceBox, type: :model do
  it { should validate_presence_of(:boundaries) }
end
