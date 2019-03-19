require 'rails_helper'

RSpec.describe CoursesController, type: :controller do

  describe "GET #show_lectures" do
    it "returns http success" do
      get :show_lectures
      expect(response).to have_http_status(:success)
    end
  end

end
