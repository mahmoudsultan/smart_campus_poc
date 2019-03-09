# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KlassRequest, type: :model do
  describe 'validations' do
    let(:request_attributes) do
      FactoryBot.attributes_for(:klass_request, :valid)
    end

    it { should validate_presence_of(:required_capacity) }
    it { should validate_presence_of(:state) }

    it 'validates state to be one of state keys' do
      invalid_state_request = request_attributes.merge(state: 'xx')

      expect { KlassRequest.create! invalid_state_request }.to raise_error ArgumentError
    end

    context 'when request is granted' do
      it 'validates presence of klass' do
        granted_request_attributes = request_attributes.merge(state: 'granted')
        expect { KlassRequest.create! granted_request_attributes }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
