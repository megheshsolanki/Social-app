# app/controllers/likes_controller.rb
class LikeController < ApplicationController
   
    def like_article
        @likeable = Article.find(params[:article_id])
        @like = @likeable.likes.find_or_initialize_by(user_id: @current_user.id)
        if @like.persisted?
            @like.destroy
            render json:{message: "Article like deleted"}
        else
            @like.save
            render json:{message: "Article like saved"}
        end 
    end
    def like_comment
        @likeable = Comment.find(params[:comment_id])
        @like = @likeable.likes.find_or_initialize_by(user_id: @current_user.id)
        if @like.persisted?
            @like.destroy
            render json:{message: "Comment like deleted"}
        else
            @like.save
            render json:{message: "Comment like saved"}
        end 
    end
end
  
