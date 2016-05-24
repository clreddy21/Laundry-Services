require 'securerandom'
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
			end
			## This takes care of creating user
			post do
		    if User.exists?(email: params[:email])
		      {:message => "Email is already taken", :success => false}
				elsif User.exists?(mobile: params[:mobile])
		      {:message => "Mobile number is already taken", :success => false}
	      elsif ![Customer, ServiceProvider, Logistic].include? params[:type]
		      {:message => "Not a valid user type.", :success => false}
				else
					otp = SecureRandom.hex(6)
					User.create!({
				    first_name:params[:first_name],
				    last_name:params[:last_name],
				    email:params[:email],
				    password:params[:password],
				    mobile:params[:mobile],
				    type:params[:type],
						otp: otp
				    # description:params[:description],
				    # avatar:params[:avatar],
				  }).save(:validate => false)

				  if User.save!
				  	{:message => 'User saved successfully', :success => true}
				  end
			  end
			end
		end

		resource :verify_otp do
			params do
				requires :email, type:String
				requires :otp, type:String
				# requires :password, type:String, regexp: /\A[a-z0-9]{6,128}+\z/
			end

			get do
				user = User.find_by(email: params[:email])
				if user.otp.to_s == params[:otp]
					user.update(:otp => '', :is_active => true)
					user.save!
					{:message => 'otp verified', :success => true}
				end
			end

		end

  end
end
