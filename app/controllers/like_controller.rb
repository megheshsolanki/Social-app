class LikeController < ApplicationController
    
    def likes_on_article 
        @article = Article.find(params[:article_id])
        @likes = @article.likes.all
        total_likes = @likes.count
        render json: {total_likes: total_likes, likes: @likes}
    end
    def likes_on_comment
        @comment = Comment.find(params[:comment_id])
        @likes = @comment.likes.all
        total_likes = @likes.count
        render json: {total_likes: total_likes, likes: @likes}
    end

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
  
