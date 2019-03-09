# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:klass) }
  it { should validate_presence_of(:state) }
end
