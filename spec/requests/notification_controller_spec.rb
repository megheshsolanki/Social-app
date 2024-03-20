require 'rails_helper'

def json 
  JSON.parse(response.body)
end

RSpec.describe "NotificationControllers", type: :request do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:access_token) { JsonWebToken.jwt_encode(user_id: user2.id) }
  before do 
    FactoryBot.create_list( :notification,10,sender: user1, reciever: user2) 
  end
  describe "GET /notifications" do
    context "when the user fetchs notifications" do
      it "should return an array of notifications" do
        get "/notifications", headers:  {"Authorization" => "Bearer #{access_token}"}
        expect(json["notifications"]).to an_instance_of(Array)
      end
      it "should return correct number of notifications" do
        get "/notifications", headers:  {"Authorization" => "Bearer #{access_token}"}
        expect(json["notifications"].size).to eq(10)
      end
      it "should return ok status code" do
        get "/notifications", headers:  {"Authorization" => "Bearer #{access_token}"}
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
