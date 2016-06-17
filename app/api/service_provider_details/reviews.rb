module ServiceProviderDetails
  class Reviews < Grape::API

    resource :add_review do
      desc 'Create new review for service provider'
      params do
        requires :service_provider_id, type:Integer
        requires :review_by_id, type:Integer
        requires :rating, type:Integer
        optional :body, type:String
      end

      post do
        service_provider = ServiceProvider.find(params[:service_provider_id])
        Review.create(:rating => params[:rating], :review_by_id => params[:review_by_id],
                      :body => params[:body], :reviewable=> service_provider)

        ratings = service_provider.reviews.pluck(:rating)

        total_ratings = ratings.size
        average_rating = ratings.sum/total_ratings

        service_provider.update(:average_review => average_rating, :reviews_count => total_ratings)

        reviews = []

        service_provider.reviews.each do |review|
          reviews << {:review_id => review.id, :review_ratind => review.rating, :review_body => review.body,
          :review_by_id => review.review_by_id, :review_by_name => User.find(review.review_by_id).full_name}
        end

        {:message => 'Successfully submitted the rating to service provider', :success => true,
         :average_review => average_rating, :reviews_count => total_ratings, :reviews => reviews}
      end
    end
  end
end
