class NotificationController < ApplicationController
    def show
        @user = @current_user 
        @notifications = Notification.where(reciever_id: @user.id)
        render json: {notifications: @notifications}, status: :ok
      end
end
