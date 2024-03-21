require 'rails_helper'

def json 
  JSON.parse(response.body)
end

RSpec.describe "FriendshipControllers", type: :request do
  let(:user1) { FactoryBot.create(:user)} 
  let(:user2) { FactoryBot.create(:user)} 
  let(:user3) { FactoryBot.create(:user)} 
  let(:user4) { FactoryBot.create(:user)}
  let(:user5) { FactoryBot.create(:user)}
  let!(:friendship1) { FactoryBot.create(:friendship, sender: user1,reciever: user2, status: "accepted") }
  let!(:friendship2) { FactoryBot.create(:friendship, sender: user1,reciever: user3, status: "pending") }
  let!(:friendship3) { FactoryBot.create(:friendship, sender: user1,reciever: user4, status: "declined", created_at: Time.now-31.days) }
  let!(:friendship4) { FactoryBot.create(:friendship, sender: user1,reciever: user5, status: "declined",created_at: Time.now-20.days) }
  let(:access_token) { JsonWebToken.jwt_encode(user_id: user1.id) }

  describe "POST /create_friend" do
    context "when the user is already friend" do
      it "should return already_friend message" do
        post "/create_friend", params: {id: user2.id}, headers: {
          "Authorization" => "Bearer #{access_token}"
        }
        expect(json["message"]).to eq("Already friends")  
      end
      it "should return ok status code" do
        post "/create_friend", params: {id: user2.id}, headers: {
          "Authorization" => "Bearer #{access_token}"
        }
        expect(response).to have_http_status(:ok)
      end
    end
    context "when the user already sent request but not accepted or rejected" do
      it "should return already_friend message" do
        post "/create_friend", params: {id: user3.id}, headers: {
          "Authorization" => "Bearer #{access_token}"
        }
        expect(json["message"]).to eq("request neither accepted nor denied")  
      end
      it "should return ok status code" do
        post "/create_friend", params: {id: user3.id}, headers: {
          "Authorization" => "Bearer #{access_token}"
        }
        expect(response).to have_http_status(:ok)
      end
    end
    context "when the request was declined and cool down is on" do
      it "should return already_friend message" do
        post "/create_friend", params: {id: user5.id}, headers: {
          "Authorization" => "Bearer #{access_token}"
        }
        expect(json["message"]).to eq("request declined (on cooldown)")  
      end
      it "should return ok status code" do
        post "/create_friend", params: {id: user5.id}, headers: {
          "Authorization" => "Bearer #{access_token}"
        }
        expect(response).to have_http_status(:ok)
      end
    end
    context "when the request was declined and cool down is expired" do
      it "should return already_friend message" do
        post "/create_friend", params: {id: user4.id}, headers: {
          "Authorization" => "Bearer #{access_token}"
        }
        expect(json["message"]).to eq("Friend request sent")  
      end
      it "should return ok status code" do
        post "/create_friend", params: {id: user4.id}, headers: {
          "Authorization" => "Bearer #{access_token}"
        }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
