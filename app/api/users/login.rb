module Users
  class Login < Grape::API
    resource :users_login do
      desc "Logging in user using jwt"
			params do
			  requires :email, type:String
			  requires :password, type:String
			end
			## This takes care of creating user's jwt
			post do
				puts params.inspect

		    if User.exists?(email: params[:email])
		    	user = User.find_by(email: params[:email])
			    if user.valid_password?(params[:password])
			    	payload = {:email => user.email}
			    	rsa_private = OpenSSL::PKey::RSA.generate 2048
						rsa_public = rsa_private.public_key
						token = JWT.encode payload, rsa_private, 'RS256'
						user.update(jwt: token)
						{"success":true, "email": params[:email], "token": token}
					else
						{"success": false, "message": "Incorrect Password"}
					end
				else
					{"success": false, "message": "Email is not registered."}
			  end
			end
		end
	end
end
