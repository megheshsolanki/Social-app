class FriendshipController < ApplicationController

   
    def create 
        @user = @current_user 
        @friend = User.find(params[:id])
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

    def accept
        @user = @current_user 
        @sender = User.find(params[:to_accept])
        @friendship = Friendship.find_by(sender_id: @sender.id, reciever_id: @user.id)
        @friendship.status = "accepted"
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
        if @friendship.destroy
          render json: {message: "Friend request declined"}, status: :ok
        else 
          render json: {message: "Friend request not declined"},status: :unprocessable_entity
        end
      end

end
