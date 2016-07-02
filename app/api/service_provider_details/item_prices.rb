module ServiceProviderDetails
  class ItemPrices < Grape::API

    resource :get_all_item_prices do
      desc 'Creating item prices of Service provider'
      params do
      end

      get do
        service_types = ServiceType.all.pluck(:id, :name)
        item_types = Item.all.pluck(:id, :name)
        service_types_hash = []
        items_hash =[]
        service_types.each do |service_type|
          service_types_hash <<{service_type_id: service_type[0], service_type_name: service_type[1]}
        end
        item_types.each do |item_type|
          items_hash <<{item_type_id: item_type[0], item_type_name: item_type[1]}
        end
        {:service_types => service_types_hash,:item_types => items_hash, :success => true}
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
            already_present_item = service_provider.item_prices.where(item_id: item_price[:item_id],
                                               service_type_id: item_price[:service_type_id], price: item_price[:price])

            if already_present_item.blank?
              service_provider.item_prices.create(item_id: item_price[:item_id],
                                                  service_type_id: item_price[:service_type_id], price: item_price[:price])
            else
              already_present_item.first.update(price: item_price[:price])
            end
          end

          message = 'Item prices list successfully updated for service provider.'

          options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services'}}

          service_provider.send_mobile_notification(options)
          {:message => message, :success => true}
        end
      end
    end
  end
end