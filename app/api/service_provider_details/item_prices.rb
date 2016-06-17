module ServiceProviderDetails
  class ItemPrices < Grape::API

    resource :create_item_prices do
      desc 'Creating item prices of Service provider'
      params do
        requires :sp_id, type:Integer
        requires :item_prices, type:Array
      end

      post do
        service_provider = ServiceProvider.find(params[:sp_id])
        if service_provider.nil?
          {:message => 'please send a valid service provider id', :success => false}
        else
          item_prices = params[:item_prices]
          item_prices.each do |item_price|
            service_provider.item_prices.create(item_id: item_price[:item_id],
                                                service_type_id: item_price[:service_type_id], price: item_price[:price])
          end
          {:message => 'Item price successfully update for service provider.', :success => true}
        end
      end
    end
  end
end
