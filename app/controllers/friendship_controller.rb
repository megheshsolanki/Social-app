class FriendshipController < ApplicationController

   
    def create 
        @user = @current_user 
        @friend = User.find(params[:id])

        @check_friend = Friendship.find_by(sender_id: @user,reciever_id: @friend.id)
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

    def accept
        @user = @current_user 
        @sender = User.find(params[:to_accept])
        @friendship = Friendship.find_by(sender_id: @sender.id, reciever_id: @user.id)
        @friendship.status = "accepted"
        Friendship.create(sender_id: @current_user.id, reciever_id: @sender.id, status:'accepted')
        @notification = Notification.find_by(sender_id: @sender.id,reciever_id: @user.id, notification_type: 'friendship request')
        @notification.destroy
        if @friendship.save 
          render json: {message: "Friend request accepted"}, status: :ok
        else 
          render json: {message: "Friend request not accepted"}, status: :unprocessable_entity
        end
    end

    def decline
        @user = @current_user 
        @sender = User.find(params[:to_decline])
        @friendship = Friendship.find_by(sender_id: @sender.id, reciever_id: @user.id)
        @notifications = Notification.find_by(sender_id: @sender.id,reciever_id: @user.id, notification_type: 'friendship request')
        @notification.destroy
        @friendship.status = "declined"
        render json: {message: "Friend request declined"}, status: :ok 
      end

end
