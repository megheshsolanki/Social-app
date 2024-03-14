class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request
    def login 
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
            access_token = JsonWebToken.jwt_encode(user_id: @user.id)
            refresh_token = JsonWebToken.jwt_encode(user_id: @user.id,exp: 6.months.from_now)
            render json: {access_token: access_token, refresh_token: refresh_token}, status: :ok
        else
            render json: {error: 'unauthorized'}, status: :unauthorized
        end
    end

    def refresh 
        decoded_token = JsonWebToken.jwt_decode(params[:refresh_token])
        if decoded_token && decoded_token["user_id"]
            @user = User.find(decoded_token["user_id"])
            if decoded_token["exp"] >= Time.now.to_i
                access_token = JsonWebToken.jwt_encode(user_id: @user.id)
                render json: {access_token: access_token}, status: :ok
            else
                render json: {message: "Refresh token expired"}, status: :unauthorized
            end
        else
            render json: {message: "Invalid refresh token"}, status: :unauthorized
        end
    end
    
end
