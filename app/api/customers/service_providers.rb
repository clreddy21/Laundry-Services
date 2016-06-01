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
        service_type_id = ServiceType.find_by(:name => service_type)

        service_provider_ids = ItemPrice.where(service_type_id:service_type_id).pluck(:service_provider_id).uniq
        service_providers = ServiceProvider.where(id: service_provider_ids)
        service_providers.near([params[:latitude], params[:longitude]], params[:distance], :units => :km)   # venues within 20 miles of a point
        service_providers.select(:id, :first_name, :last_name, :mobile,  :reviews_count, :average_review, :latitude, :longitude, :email)
      end
    end
    resource :get_service_provider_item_prices do
      desc "Get service provider's prices for different items."
      params do
        requires :service_provider_id, type:String
      end
      # This gets service providers in the specified distance and service type
      post do
        puts params.inspect
        service_provider = ServiceProvider.find(params[:service_provider_id])
        if service_provider.nil?
          {:message => 'No service provider with the provided id', :success => false}
        else
          item_prices = service_provider.item_prices.includes(:item, :service_type)
          item_prices_hash = []
          item_type_ids = item_prices.pluck(:item_id).uniq
          items = Item.find(item_type_ids)

          items.each do |item|
            prices = []
            item_item_prices = item_prices.where(:item_id => item.id)
            item_item_prices.each do |item_item_price|
              prices << {service_type_id: item_item_price.service_type_id, service_type_name: item_item_price.service_type.name,
               price: item_item_price.price}
            end
            item_prices_hash << {item_id: item.id, item_name: item.name, prices: prices}
          end


          # item_prices.each do |item_price|
          #   item_prices_hash << {item_id: item_price.item_id,
          #                        item_name: item_price.item.name, service_type_id: item_price.service_type_id,
          #                        service_type_name: item_price.service_type.name,price: item_price.price}
          # end

          item_prices_hash
          # raise 'boom'
        end
      end
    end

  end
end