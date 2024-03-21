require 'rails_helper'

def json 
  JSON.parse(response.body)
end

RSpec.describe "ForgotPasswordControllers", type: :request do
  let(:user) { FactoryBot.create(:user) }
  describe "POST /forgot_password" do
    context "existing user requests forgot password" do
      it "should send email to the user" do
        post "/forgot_password", params: { email: user.email}
        expect(json["message"]).to eq("OTP sent")
      end
      it "should return ok status code" do
        post "/forgot_password", params: { email: user.email}
        expect(response).to have_http_status(:ok)
      end
    end
    context "non existing user requests forgot password" do
      it "should send email to the user" do
        post "/forgot_password", params: { email: "nonexistinguser@example.com"}
        expect(json["error"]).to eq("User not found.")
      end
      it "should return not found status code" do
        post "/forgot_password", params: { email: "nonexistinguser@example.com"}
        expect(response).to have_http_status(:not_found)
      end
    end
  end
  describe "POST /password_reset" do
    context "valid user with valid otp and password" do 
      it "should reset password" do 
        post "/password_reset", params: { password:  Faker::Internet.password(min_length: 8,mix_case: true, special_characters: true) , otp: user.otp }
        expect(json["message"]).to eq("Password reset successful.")
      end
      it "should return ok status code" do 
        post "/password_reset", params: { password:  Faker::Internet.password(min_length: 8,mix_case: true, special_characters: true) , otp: user.otp }
        expect(response).to have_http_status(:ok)
      end
    end
    context "valid user with invalid otp" do 
      it "should return error" do 
        post "/password_reset", params: { password:  Faker::Internet.password(min_length: 8,mix_case: true, special_characters: true) , otp: 96 }
        expect(json["error"]).not_to be_empty
      end
      it "should return unproccessable content status code" do 
        post "/password_reset", params: { password:  Faker::Internet.password(min_length: 8,mix_case: true, special_characters: true) , otp: 96 }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
