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
  describe "PATCH /article/:article_id/comment/:id" do 
    context "when correct user with valid params update" do 
      it "should update the comment and return updated comment" do
        comment_params = { comment: valid_params }
        patch "/article/#{article.id}/comment/#{comment.id}", params: comment_params, headers: { "Authorization" => "Bearer #{access_token2}" }
         expect(json["body"]).to eq(valid_params[:body])
      end
      it "should return ok status code" do
        comment_params = { comment: valid_params }
        patch "/article/#{article.id}/comment/#{comment.id}", params: comment_params, headers: { "Authorization" => "Bearer #{access_token2}" }
         expect(response).to have_http_status(:ok)
      end
    end
    context "when other user with valid params update" do 
      it "should return error giving unauthorized message" do
        comment_params = { comment: valid_params }
        patch "/article/#{article.id}/comment/#{comment.id}", params: comment_params, headers: { "Authorization" => "Bearer #{access_token1}" }
         expect(json["error"]).to eq("Not authorized to edit this comment")
      end
      it "should return unauthorized status code" do
        comment_params = { comment: valid_params }
        patch "/article/#{article.id}/comment/#{comment.id}", params: comment_params, headers: { "Authorization" => "Bearer #{access_token1}" }
         expect(response).to have_http_status(:unauthorized)
      end
    end
    context "when correct user with invalid params update" do
      it "should return error" do
        comment_params = { comment: invalid_params }
        patch "/article/#{article.id}/comment/#{comment.id}", params: comment_params, headers: { "Authorization" => "Bearer #{access_token2}" }
         expect(json["error"]).not_to be_empty
      end
      it "should return unprocessable content status code" do
        comment_params = { comment: invalid_params }
        patch "/article/#{article.id}/comment/#{comment.id}", params: comment_params, headers: { "Authorization" => "Bearer #{access_token2}" }
         expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "DELETE /article/:article_id/comment/:id" do 
    context "when correct user tries to delete" do 
      it "should delete the comment" do
        delete "/article/#{article.id}/comment/#{comment.id}", headers: { "Authorization" => "Bearer #{access_token2}" }
         expect(json["message"]).to eq("Comment deleted")
      end
      it "should return ok status code" do
        delete "/article/#{article.id}/comment/#{comment.id}", headers: { "Authorization" => "Bearer #{access_token2}" }
         expect(response).to have_http_status(:ok)
      end
    end
    context "when other user tries to delete" do 
      it "should return error giving unauthorized message" do
        delete "/article/#{article.id}/comment/#{comment.id}", headers: { "Authorization" => "Bearer #{access_token1}" }
         expect(json["error"]).to eq("Not authorized to delete this comment")
      end
      it "should return unauthorized status code" do
        delete "/article/#{article.id}/comment/#{comment.id}", headers: { "Authorization" => "Bearer #{access_token1}" }
         expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
