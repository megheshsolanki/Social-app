require 'rails_helper'
require 'jwt'
def json
  JSON.parse(response.body)
end

RSpec.describe "Authentications", type: :request do
  describe "POST /login" do
    let(:user) {FactoryBot.create(:user)}
    context "with valid params" do
      it "should return access token" do
        post "/login", params: {
          email: user.email,
          password: user.password
        }
        expect(json['access_token']).to be_present
      end
      it "should return refresh token" do
        post "/login", params: {
          email: user.email,
          password: user.password
        }
        expect(json['refresh_token']).to be_present
      end
      it "should return ok status" do
        post "/login", params: {
          email: user.email,
          password: user.password
        }
        expect(response).to have_http_status(:ok)  
      end
    end
    context "with invalid params" do
      it "should return error" do
        post "/login", params: {
          email: user.email,
          password: "user.password"
        }
        expect(json['error']).to be_present
      end
      it "should return 401 status" do
        post "/login", params: {
          email: user.email,
          password: "user.password"
        }
        expect(response).to have_http_status(:unauthorized)  
      end
    end
  end
  describe "post /refresh" do
    let(:user) {FactoryBot.create(:user)}
    let(:refresh_token) { JsonWebToken.jwt_encode(user_id: user.id) }
    context "valid parameters" do
      it 'returns access_token' do
        post "/refresh", params: {
          refresh_token: refresh_token
        }
        expect(json['access_token']).to be_present
      end
      it "returns ok status code" do
        post "/refresh", params: {
          refresh_token: refresh_token
        }
        expect(response).to have_http_status(:ok)
      end
    end
    context "invalid parameters" do
      it "should return message saying refresh token missing" do
        post "/refresh"
        expect(json['message']).to eq("refresh token missing")
      end
      it "should return unauthorized status code" do
        post "/refresh"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
