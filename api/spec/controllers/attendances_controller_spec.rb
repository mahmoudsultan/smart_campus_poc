require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
    describe "#get" do
        context "given a valid image" do
            it "returns detected locations" do
                img = Base64.encode64(file_fixture("IMG_20190224_172925-min.jpg").read)
                ret_val = get :get, params: {image: img, info: 0}
                

                puts JSON.parse(result.body)
                # puts ret_val.to_json
                expect(response).to have_http_status(:success)
            end
        end
    end
end
