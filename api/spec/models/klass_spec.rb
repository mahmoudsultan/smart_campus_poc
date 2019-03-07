# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Klass, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:floor) }
  it { should validate_presence_of(:capacity) }

  it { should belong_to(:building) }
end
