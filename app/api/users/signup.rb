module Users
  class Signup < Grape::API

    resource :users do
      # desc "List all Users"
      # get do
      #   User.all
      # end
    
		
			desc "Create a new user"
			## This takes care of parameter validation
			params do
			  requires :first_name, type:String
			  requires :last_name, type:String
			  requires :email, type:String
			  requires :password, type:String, regexp: /\A[a-z0-9]{6,128}+\z/

			  requires :mobile, type:String
			  # requires :description, type:String
			  # requires :avatar, type:String
			  requires :type, type:String
			  optional :latitude, type:Float
			  optional :longitude, type:Float
			end
			## This takes care of creating user
			post do
				puts params.inspect
				# params = JSON.parse params.inspect
		    if User.exists?(email: params[:email])
		      {:message => "Email is already taken", :success => false}
				elsif User.exists?(mobile: params[:mobile])
		      {:message => "Mobile number is already taken", :success => false}
	      elsif !['Customer', 'ServiceProvider', 'Logistic'].include? params[:type]
		      {:message => "Not a valid user type.", :success => false}
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
						longitude: params[:longitude]
				    # description:params[:description],
				    # avatar:params[:avatar],
				  }).save(:validate => false)

					user = User.find_by(:email => params[:email])
				  if user.present?
				  	{:message => 'Registration successful.', :success => true, :user_id => user.id}
				  else
				  	{:message => 'Not able to save user, Try again', :success => false}
				  end
			  end
			end
		end

		resource :verify_otp do
			params do
				requires :user_id, type:String
				requires :otp, type:String
				# requires :password, type:String, regexp: /\A[a-z0-9]{6,128}+\z/
			end

			post do
				puts params.inspect
				user = User.find(params[:user_id])
				if user.nil?
					{:message => "No user exists with this user_id", :success => false}
				elsif user.otp.to_s == ''
					{:message => "User already verified.", :success => true}
				elsif user.otp.to_s == params[:otp]
					user.update(:otp => '', :is_active => true)
					user.save!
		    	payload = {:email => user.email}
		    	rsa_private = OpenSSL::PKey::RSA.generate 2048
					rsa_public = rsa_private.public_key
					token = JWT.encode payload, rsa_private, 'RS256'
					user.update(jwt: token)
					{:message => 'otp verified', :success => true, :token => token}
				end
			end
		end
  end
end
