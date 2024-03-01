require "jwt"
module JsonWebToken 
    extended ActiveSupport::Concern
     

    def jwt_encode(payload, exp = 7.days.from_now) 
        payload[:exp] = exp.to_i
        JWT.encode(payload,ENV["SECRET_KEY"])
    end

    def jwt_decode(token)
        if token != nil
            decoded = JWT.decode(token,ENV["SECRET_KEY"])[0]
            HashWithIndifferentAccess.new decoded
        else
            return nil 
        end
        
    end
end