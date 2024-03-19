require 'rails_helper'
def json
  JSON.parse(response.body)
end
RSpec.describe "CommentControllers", type: :request do
  let(:user1)  { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:access_token1) { JsonWebToken.jwt_encode(user_id: user1.id) }
  let(:access_token2) { JsonWebToken.jwt_encode(user_id: user2.id) }
  let!(:article) { FactoryBot.create(:article, user: user1) }
  let(:comment) { FactoryBot.create(:comment, article: article, user: user2) }
  let(:valid_params) { FactoryBot.attributes_for(:comment) }
  let(:invalid_params) { FactoryBot.attributes_for(:comment,body: "") }

  describe "POST /article/:id/comment" do
    context "with valid params" do
      it "should add comment to the article" do 
        comment_params = { comment: valid_params }
        post "/article/#{article.id}/comment", params: comment_params, headers: { "Authorization" => "Bearer #{access_token2}"}
        expect(json["body"]).to eq(valid_params[:body])
      end
      it "should return created status code" do 
        comment_params = {comment: valid_params}
        post "/article/#{article.id}/comment", params: comment_params, headers: { "Authorization" => "Bearer #{access_token2}"}
        expect(response).to have_http_status(:created)
      end
    end
    context "with invalid params" do
      it "should return the error" do 
        comment_params = { comment: invalid_params }
        post "/article/#{article.id}/comment", params: comment_params, headers: { "Authorization" => "Bearer #{access_token2}"}
        expect(json['errors']).to be_present 
      end
      it "should return unproccessable content status code" do 
        comment_params = {comment: invalid_params}
        post "/article/#{article.id}/comment", params: comment_params, headers: { "Authorization" => "Bearer #{access_token2}"}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "GET /article/:id/comment" do 
    context "with valid params" do
      it "should return all the comments in an array" do 
        get "/article/#{article.id}/comment", headers: { "Authorization" => "Bearer #{access_token1}" }
        puts json
        expect(json).to an_instance_of(Array) 
      end
      it "should return ok status code" do 
        get "/article/#{article.id}/comment", headers: { "Authorization" => "Bearer #{access_token1}" }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
