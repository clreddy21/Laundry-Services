module Users
  class UserAddress < Grape::API

    resource :list_of_addresses do
      desc 'List of address of a user'
      params do
        requires :user_id, type:Integer
      end

      post do
        puts params.inspect

        if User.exists?(id: params[:user_id])
          user = User.includes(:addresses).find_by(id: params[:user_id])
          addresses = user.addresses.is_active.select(:id, :address, :is_active)
          {:success => true, addresses: addresses}

        else
          {:success => false, :message => 'Invalid user Id.'}
        end
      end
    end

    resource :new_address do
      desc 'Add new address to user'
      params do
        requires :user_id, type:Integer
        requires :address, type:String
      end

      post do
        puts params.inspect

        if User.exists?(id: params[:user_id])
          user = User.find_by(id: params[:user_id])
          address = user.addresses.create(address: params[:address])
          {:success => true, :message => 'New address added successfully.', address: address}

        else
          {:success => false, :message => 'Invalid user Id.'}
        end
      end
    end

    resource :delete_address do
      desc 'Delete address of user'
      params do
        requires :user_id, type:Integer
        requires :address_id, type:Integer
      end

      post do
        puts params.inspect

        if User.exists?(id: params[:user_id])
          user = User.find_by(id: params[:user_id])
          if Address.exists?(id: params[:address_id])
            address = Address.find_by(id: params[:address_id])
            if user.addresses.include? address
              address.update(is_active: false)
              {:success => true, :message => 'Address deleted successfully.'}
            else
              {:success => false, :message => "This address doesn't belong to the user."}
            end
          else
            {:success => false, :message => 'Invalid address Id.'}
          end
        else
          {:success => false, :message => 'Invalid user Id.'}
        end
      end
    end
  end
end
