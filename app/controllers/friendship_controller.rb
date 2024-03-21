class FriendshipController < ApplicationController

   
    def create 
        @user = @current_user 
        @friend = User.find(params[:id])
        @check_friend = Friendship.find_by(sender_id: @user.id,reciever_id: @friend.id)
        if @check_friend
          case @check_friend.status
          when "accepted" 
            render json: {message: "Already friends"}, status: :ok
          when "pending"
            render json: {message: "request neither accepted nor denied"}, status: :ok
          when "declined"
            if @check_friend.created_at <= 30.days.ago
              @check_friend.destroy
              @friendship = Friendship.new(sender_id: @current_user.id, reciever_id: @friend.id, status:'pending')
              @notification = Notification.new(sender_id: @current_user.id, reciever_id: @friend.id,notification_type: 'friendship request')
              if @friendship.save 
                  if @notification.save 
                      render json: {note: "Notification sent", sender: @user.name, reciever: @friend.name, message: "Friend request sent"}, status: :ok
                  else 
                      render json: {sender: @user.name, reciever: @friend.name, message: "Friend request not send", error: @friendship.errors.full_messages}, status: :unprocessable_entity
                  end
              end
            else
              render json: {message: "request declined (on cooldown)"}, status: :ok
            end      
          end
        else
          blocked = BlockedUser.find_by(blocked_by: @current_user.id, blocked: @friend.id) 
          if blocked 
            render json: {message: "user blocked by you, unblock to send request"}, status: :ok 
          else 
            @friendship = Friendship.new(sender_id: @current_user.id, reciever_id: @friend.id, status:'pending')
            @notification = Notification.new(sender_id: @current_user.id, reciever_id: @friend.id,notification_type: 'friendship request')
            if @friendship.save 
                if @notification.save 
                    render json: {note: "Notification sent", sender: @user.name, reciever: @friend.name, message: "Friend request sent"}, status: :ok
                else 
                    render json: {sender: @user.name, reciever: @friend.name, message: "Friend request not send", error: @friendship.errors.full_messages}, status: :unprocessable_entity
                end
            end
          end
        end
    end

    def accept
        @user = @current_user 
        @sender = User.find(params[:to_accept])
        @friendship = Friendship.find_by(sender_id: @sender.id, reciever_id: @user.id)
        @friendship.status = "accepted"
        Friendship.create(sender_id: @current_user.id, reciever_id: @sender.id, status:'accepted')
        @notification = Notification.find_by(sender_id: @sender.id,reciever_id: @user.id, notification_type: 'friendship request')
        @notification.destroy if @notification
        @friendship.save 
        render json: {message: "Friend request accepted"}, status: :ok
        
    end

    def decline
        @user = @current_user 
        @sender = User.find(params[:to_decline])
        @friendship = Friendship.find_by(sender_id: @sender.id, reciever_id: @user.id)
        @notifications = Notification.find_by(sender_id: @sender.id,reciever_id: @user.id, notification_type: 'friendship request')
        @notification.destroy if @notification
        @friendship.status = "declined"
        @friendship.save
        render json: {message: "Friend request declined"}, status: :ok 
      end
    
    def block
      if BlockedUser.find_by(blocked_by_id: @current_user.id, blocked_id: params[:id])
        render json: {message: "User already blocked"}, status: :ok 
      else 
        @friendship = Friendship.find_by(sender_id: params[:id],reciever_id: @current_user.id)
        if @friendship
          @friendship.destroy
          @friendship = Friendship.find_by(sender_id: @current_user.id,reciever_id: params[:id])
          @friendship.destroy 
        end
        @shared_articles = SharedArticle.all.where(shared_by: @current_user.id, owned_by: params[:id])
        if @shared_articles.size > 0
          @shared_articles.each do |shared_article|
            shared_article.update(status: "inactive")
          end
        end
        @shared_articles = SharedArticle.all.where(shared_by: params[:id], owned_by: @current_user.id)
        if @shared_articles.size > 0
          @shared_articles.each do |shared_article|
            shared_article.update(status: "inactive")
          end
        end
        @user = @current_user
        @blocked = User.find(params[:id])
        @blocked_user = BlockedUser.create(blocked_id: @blocked.id, blocked_by_id: @current_user.id)
        if @blocked_user.save
          render json: {blocked: @blocked_user, message: "User blocked"}, status: :ok
        end
      end
    end

    def unblock
      @block = BlockedUser.find_by(blocked_id: params[:id], blocked_by_id: @current_user.id)
      if @block 
        @shared_articles = SharedArticle.all.where(shared_by: @current_user.id, owned_by: params[:id])
        if @shared_articles.size > 0
          @shared_articles.each do |shared_article|
            shared_article.update(status: "active")
          end
        end
        @shared_articles = SharedArticle.all.where(shared_by: params[:id], owned_by: @current_user.id)
        if @shared_articles.size > 0
          @shared_articles.each do |shared_article|
            shared_article.update(status: "active")
          end
        end
        @block.destroy
        render json: {message: "User unblocked"}, status: :ok 
      else 
        render json: {message: "User was not blocked"}, status: :ok
      end
    end

end
