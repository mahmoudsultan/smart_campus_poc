require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
    describe "#get" do
        context "given a valid image" do
            it "returns detected locations" do
                img = Base64.encode64(file_fixture("IMG_20190224_172925-min.jpg").read)
                get :get, params: {image: img, 'ids'=> ['rana', 'ezz', 'magdy', 'aly', 'taw2am', 123]}
                expect(response).to have_http_status(:success)
            end
        end
    end

    describe "#get_attendance" do
        context "given a class_id" do
            it "gets a single frame and returns detected students" do
                get :get_attendance, params: {class_id: 1}
                expect(response).to have_http_status(:success)
            end
        end
    end

end
