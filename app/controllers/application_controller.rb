class ApplicationController < ActionController::API
    before_action :authenticate_request
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from JWT::DecodeError, with: :jwt_decode_error
    def record_not_found
      render json: {error: "Not found"}, status: :not_found
    end
    
    private 
    def authenticate_request 
        header = request.headers["Authorization"]
        if header.present? && header.split(" ").first == "Bearer"
            token = header.split(" ").last 
            decoded = JsonWebToken.jwt_decode(token)
            if decoded.present? && decoded.key?(:user_id)
                @current_user = User.find(decoded["user_id"])
            else 
                render json: {error: "Invalid Token"}, status: :unauthorized
            end
        else
            render json: {error: "Authorization token missing"}, status: :unauthorized
        end
    end

    def jwt_decode_error(exception)
        render json: { error: exception.message }, status: :unauthorized
    end
end
