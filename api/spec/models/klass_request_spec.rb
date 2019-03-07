# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KlassRequest, type: :model do
  it { should validate_presence_of(:required_capacity) }
  it { should validate_presence_of(:state) }
end
