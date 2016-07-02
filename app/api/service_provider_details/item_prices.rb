module ServiceProviderDetails
  class ItemPrices < Grape::API

    resource :get_all_item_prices do
      desc 'Creating item prices of Service provider'
      params do
      end

      get do
        service_types = ServiceType.all.pluck(:id, :name)
        item_types = Item.all.pluck(:id, :name)

        {:service_types => service_types,:item_types => item_types, :success => true}

      end
    end

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

          message = 'Item price successfully added for service provider.'

          options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services'}}

          service_provider.send_mobile_notification(options)
          {:message => message, :success => true}
        end
      end
    end


    resource :update_item_prices do
      desc 'Updating item prices of Service provider'
      params do
        requires :sp_id, type:Integer
        requires :item_prices, type:Array
      end

      post do
        service_provider = ServiceProvider.includes(:item_prices).find(params[:sp_id])
        if service_provider.nil?
          {:message => 'please send a valid service provider id', :success => false}
        else
          item_prices = params[:item_prices]
          item_prices.each do |item_price|
            ip = ItemPrice.find(item_price[:item_price_id])

            if service_provider.item_prices.include? ip
              ip.update(price: item_price[:price])
            end
          end

          message = 'Item price successfully updated for service provider.'

          options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services'}}

          service_provider.send_mobile_notification(options)
          {:message => message, :success => true}
        end
      end
    end
  end
end
