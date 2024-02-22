# app/controllers/likes_controller.rb
class LikeController < ApplicationController
   
    def like_article
        @likeable = Article.find(params[:article_id])
        @like = @likeable.likes.create(user_id: @current_user.id)
        @like.save 
        render json: {message: "Article liked successfully"}, status: :ok 
    end
    def like_comment
        @likeable = Comment.find(params[:comment_id])
        @like = @likeable.likes.create(user_id: @current_user.id)
        @like.save 
        render json: {message: "Comment liked successfully"}, status: :ok 
    end
    def unlike_article 
        @likeable = Article.find(params[:article_id])
        @like = @likeable.likes.find(user_id: @current_user.id)
        @like.destroy 
        render json: {message: "Article unliked successfully"}, status: :ok
    end
    def unlike_comment
        @likeable = Comment.find(params[:comment_id])
        @like = @likeable.likes.find(user_id: @current_user.id)
        @like.destroy 
        render json: {message: "Comment unliked successfully"}, status: :ok
    end
end
  
