# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentsController, type: :controller do

  let(:valid_attributes) do
    FactoryBot.attributes_for :user, :student
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:user, :student).merge(student_id: '')
  end

  describe 'GET #index' do
    it 'returns a success response' do
      User.student.create! valid_attributes
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      student = User.student.create! valid_attributes
      get :show, params: { id: student.to_param }
      expect(response).to be_successful
    end

    it 'returns a success response when fetched using student id' do
      student = User.student.create! valid_attributes
      get :show, params: { student_id: student.student_id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Student' do
        expect do
          post :create, params: { student: valid_attributes }
        end.to change(User.student, :count).by(1)
      end

      it 'renders a JSON response with the new student' do
        post :create, params: { student: valid_attributes }

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new student' do
        post :create, params: { student: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'John Doe' }
      end

      it 'updates the requested student' do
        student = User.student.create! valid_attributes
        put :update, params: { id: student.to_param, student: new_attributes }
        student.reload
        expect(student.name).to eql 'John Doe'
      end

      it 'renders a JSON response with the student' do
        student = User.student.create! valid_attributes

        put :update, params: { id: student.to_param, student: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the student' do
        student = User.student.create! valid_attributes

        put :update, params: { id: student.to_param, student: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested student' do
      student = User.student.create! valid_attributes
      expect do
        delete :destroy, params: { id: student.to_param }
      end.to change(User.student, :count).by(-1)
    end
  end
end
