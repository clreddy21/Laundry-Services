module Users
  class Data < Grape::API

    resource :users do
      desc "List all Users"
      get do
        User.all
      end
    
		
			desc "Create a new user"
			## This takes care of parameter validation
			params do
			  requires :first_name, type:String
			  requires :last_name, type:String
			  requires :email, type:String
			  requires :password, type:String, regexp: /^\A{6,128}$/

			  requires :mobile, type:String
			  # requires :description, type:String
			  # requires :avatar, type:String
			  requires :type, type:String
			end
			## This takes care of creating employee
			post do
		    if User.exists?(email: params[:email])
		      {"error": "Email is already taken", "success": false}
				elsif User.exists?(mobile :params[:mobile])
		      {"error": "Mobile number is already taken", "success": false}
	      elsif ![Customer, ServiceProvider, Logistic].include? params[:type]
		      {"error": "Not a valid user type.", "success": false}
		    else
				  User.create!({
				    first_name:params[:first_name],
				    last_name:params[:last_name],
				    email:params[:email],
				    password:params[:password],
				    mobile:params[:mobile],
				    type:params[:type],
				    # description:params[:description],
				    # avatar:params[:avatar],
				  }).save(:validate => false)

				  if User.save!
				  	'User saved successfully'
				  end
			  end
			end
		end

  end
end
