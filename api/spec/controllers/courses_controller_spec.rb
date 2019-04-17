require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
    describe "GET #show_lectures" do
      context "given a valid params" do
        it "returns http success" do
        get :show_lectures, params: {pid: 135,term: ['fall'], year: ['2018']}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
