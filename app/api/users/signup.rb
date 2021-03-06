require 'gcm'

module Users
  class Signup < Grape::API

    resource :users do
		
			desc 'Create a new user'
			## This takes care of parameter validation
			params do
			  requires :first_name, type:String
			  requires :last_name, type:String
			  requires :email, type:String
			  requires :password, type:String, regexp: /\A[a-z0-9]{6,128}+\z/

			  requires :mobile, type:String
			  # requires :address, type:String
			  # requires :avatar, type:String
			  requires :type, type:String
			  requires :device_id, type:String
			  optional :latitude, type:Float
			  optional :longitude, type:Float
			  optional :address, type:String
			end
			## This takes care of creating user
			post do
				puts params.inspect
				# params = JSON.parse params.inspect
		    if User.exists?(email: params[:email])
		      {:message => 'Email is already taken', :success => false}
				elsif User.exists?(mobile: params[:mobile])
		      {:message => 'Mobile number is already taken', :success => false}
	      elsif !['Customer', 'ServiceProvider', 'Logistic'].include? params[:type]
		      {:message => 'Not a valid user type.', :success => false}
				else
					otp = rand(1000..9999)
					User.create!({
				    first_name:params[:first_name],
				    last_name:params[:last_name],
				    email:params[:email],
				    password:params[:password],
				    password_confirmation:params[:password],
				    mobile:params[:mobile],
				    type:params[:type],
						otp: otp,
						latitude: params[:latitude],
						longitude: params[:longitude],
						gcm_id: params[:device_id],
				    status: 'active'
				    # description:params[:description],
				    # avatar:params[:avatar],
				  }).save(:validate => false)

					user = User.find_by(:email => params[:email])
				  if user.present?
						# Address.create(address: params[:address], :addressable  => user)
						Wallet.create(amount: 0.0, user_id: user.id)
						gcm = GCM.new('AIzaSyCEVI-nKDlS-QieHzg75HCjodx4GlOr3CM')
						registration_id = params[:device_id]
						if user.type == 'ServiceProvider'
							user.build_item_prices
						end
						options = {data: {score: '123', 'isFromNotification' => false}, collapse_key: 'updated_score'}
						response = gcm.send(registration_id, options)
						message = 'Registration successful.'
				    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'isFromNotification' => false}}

						user.send_mobile_notification(options)
						{:message => message, :success => true, :user_id => user.id}
					else
						# user.send_mobile_notification('Not able to save user, Try again')
				  	{:message => 'Not able to save user, Try again', :success => false}
				  end
			  end
			end
		end

		resource :resend_otp do
			params do
				requires :user_id
			end

			post do
				puts params.inpsect

				user = User.find_by(id: params[:user_id])

				if user.nil?
					{:message => 'No user exists with this user_id', :success => false}
				else
					otp = rand(1000..9999)
					user.update(otp: otp)
					user.send_otp_to_user
					{:message => 'OTP sent again', :success => true}
				end
			end
		end

		resource :update_device_id do
			params do
				requires :user_id
				requires :device_id
			end

			post do
				puts params.inpsect

				user = User.find_by(id: params[:user_id])
				gcm_id = params[:device_id]

				if user.nil?
					{:message => 'No user exists with this user_id', :success => false}
				else
					user.update(gcm_id: gcm_id)
					{:message => 'Device Id of user updated successfully', :success => true}
				end
			end
		end

		resource :verify_otp do
			params do
				requires :user_id, type:String
				requires :otp, type:String

			end

			post do
				puts params.inspect
				user = User.find_by(id: params[:user_id])

				if user.nil?
					{:message => 'No user exists with this user_id', :success => false}
				elsif user.otp.blank?
					{:message => 'User already verified.', :success => true}
				elsif user.otp.to_s == params[:otp]
					user.update(:otp => '', :is_active => true, :is_verified => true)
					user.save!
		    	payload = {:email => user.email}
		    	rsa_private = OpenSSL::PKey::RSA.generate 2048
					rsa_public = rsa_private.public_key
					token = JWT.encode payload, rsa_private, 'RS256'
					user.update(jwt: token)
					{:message => 'otp verified', :success => true, :token => user.jwt}
				end
			end
		end

		resource :forgot_password_request do
			params do
				requires :mobile, type:String
			end

			post do
				puts params.inspect
				otp = rand(1000..9999)
				user = User.find_by(mobile: params[:mobile])
				if user.nil?
					{:message => 'No user exists with this mobile', :success => false}
				else
					user.update(otp: otp)
					user.send_forgot_password_otp
					{:message => 'otp sent to mobile', :success => true}
				end
			end
		end

		resource :forgot_password_otp_verification do
			params do
				requires :mobile, type:String
				requires :otp, type:String
				requires :password, type:String, regexp: /\A[a-z0-9]{6,128}+\z/
			end

			post do
				puts params.inspect
				user = User.find_by(mobile: params[:mobile])
				if user.nil?
					{:message => 'No user exists with this mobile', :success => false}
				elsif user.otp != params[:otp]
					{:message => 'Wrong OTP, please try again', :success => false}
				else
					user.update(otp: nil, password: params[:password])
					{:message => 'Password updated successfully.', :success => true}
				end
			end
		end
  end
end
