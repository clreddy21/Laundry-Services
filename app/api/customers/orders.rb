module Customers
  class Orders < Grape::API
    resource :create_order do
      desc "Create a new order"

      params do
        requires
      end

    end
  end
end
