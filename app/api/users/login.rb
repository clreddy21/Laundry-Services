module Users
  class Login < Grape::API
    resource :users_login do
      desc 'Logging in user using jwt'
			params do
			  requires :email, type:String
			  requires :password, type:String, regexp: /\A[a-z0-9]{6,128}+\z/
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
						address = user.address ? user.address.address : ''

						if user.is_customer?
							wallet_amount = user.wallet.amount
							{:success => true, :email => params[:email], :token => user.jwt, :name => user.first_name + user.last_name,
							 :mobile_number => user.mobile, :user_id => user.id, :address => address, wallet_amount: wallet_amount}
						elsif user.is_service_provider?
							service_provider = user
							total_number_of_orders = service_provider.service_provider_stats[:orders_count]
							total_amount_earned = service_provider.service_provider_stats[:total_cost]
							{:success => true, :email => params[:email], :token => user.jwt, :name => user.first_name + user.last_name,
							 :mobile_number => user.mobile, :user_id => user.id, :address => address, :total_number_of_orders => total_number_of_orders,
							:total_amount_earned => total_amount_earned}
						elsif user.is_logistic?
							total_number_of_orders= logistic.logistic_stats[:orders_count]
							total_amount_earned = logistic.logistic_stats[:total_cost]
							{:success => true, :email => params[:email], :token => user.jwt, :name => user.first_name + user.last_name,
							 :mobile_number => user.mobile, :user_id => user.id, :address => address, :total_number_of_orders => total_number_of_orders,
							 :total_amount_earned => total_amount_earned}
						end
					else
						{:success => false, :message => 'Incorrect Password'}
					end
				else
					{:success => false, :message => 'Email is not registered.'}
			  end
			end
		end

		resource :change_password do
			desc 'Change Password'
			params do
				requires :user_id, type:Integer
				requires :old_password, type:String, regexp: /\A[a-z0-9]{6,128}+\z/
				requires :new_password, type:String, regexp: /\A[a-z0-9]{6,128}+\z/
			end

			post do
				puts params.inspect
				user = User.find(params[:user_id])
				if user.valid_password?(params[:old_password])
					user.update(password: params[:new_password])
					message = 'Password changed successfully'
			    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services'}}
					user.send_mobile_notification(options)
					{message:'Password changed successfully', :success => true}
				else
					{message:'Incorrect old Password', :success => false}
				end
			end
		end

	end
end
