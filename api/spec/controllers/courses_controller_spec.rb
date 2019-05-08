require 'rails_helper'

terms = %i[fall spring summer]
# profs = User.where(role: :professor).select(:id)
profs = (1..3).to_a
# years = CourseOffering.distinct.pluck(:year)
years = (2017..2019).to_a

RSpec.describe CoursesController, type: :controller do
    describe "GET #show_lectures" do
      context "when valid params" do
        it "returns http success" do
          profs.each do |profid|
            terms.each do |term|
              years.each do |year|
                get :show_lectures, params: {pid: profid, term: term, year: year}
                expect(response).to have_http_status(:success)
              end
            end
          end
        end
      end
    end
  end
