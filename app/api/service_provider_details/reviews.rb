module ServiceProviderDetails
  class Reviews < Grape::API

    resource :add_review do
      desc "Create new review for service provider"
      params do
        requires :service_provider_id, type:Integer
        requires :rating, type:Integer
      end

      post do
        service_provider = ServiceProvider.find(params[:service_provider_id])
        Review.create(rating: params[:rating], :reviewable=> service_provider)

        {:message => "Successfully submitted the rating to service provider", :success => true}
      end
    end
  end
end
