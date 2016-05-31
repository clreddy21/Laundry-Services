module Customers
  class ServiceProviders < Grape::API
    resource :get_service_providers do
      desc "Get service providers depending upon distance and service provided"
      params do
        requires :latitude, type:Float
        requires :longitude, type:Float
        requires :distance, type:Integer
        requires :service_type, type:String
      end
      # This gets service providers in the specified distance and service type
      post do
        puts params.inspect
        service_type = params[:service_type].to_s
        case service_type
          when 'wash'
            service_providers = ServiceType.where(:wash => true).collect(&:user_id)
          when 'iron'
            service_providers = ServiceType.where(:iron => true).collect(&:user_id)
          when 'wash_iron'
            service_providers = ServiceType.where(:wash_iron => true).collect(&:user_id)
          when 'dry_cleaning'
            service_providers = ServiceType.where(:dry_cleaning => true).collect(&:user_id)
          end

        service_providers = ServiceProvider.where(id: service_providers)
        service_providers.near([params[:latitude], params[:longitude]], params[:distance], :units => :km)   # venues within 20 miles of a point
        service_providers.pluck(:id, :first_name, :last_name, :mobile,  :reviews_count, :average_review, :latitude, :longitude, :email)
      end
    end
    resource :get_service_provider_item_prices do
      desc "Get service provider's prices for different items."
      params do
        requires :service_provider_id, type:String
      end
      # This gets service providers in the specified distance and service type
      put do
        puts params.inspect
        service_provider = ServiceProvider.find(params[:service_provider_id])
        if service_provider.nil?
          {:message => 'No service provider with the provided id', :success => false}
        else
          item_prices = ItemPrice.includes(:item).where(user_id: service_provider.id)
          item_prices_hash = []
          item_prices.each do |item_price|
            item_prices_hash << {service_provider_id: params[:service_provider_id], item_id: item_price.item_id,
                                 item_name: item_price.item.name, wash: item_price.wash, iron: item_price.iron,
                                wah_iron: item_price.wash_iron, dry_cleaning: item_price.dry_cleaning}
          end

          item_prices_hash
        end
      end
    end

  end
end