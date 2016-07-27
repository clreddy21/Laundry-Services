Rails.application.routes.draw do
  mount API => '/'

  Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: 'users/sessions', registrations: 'users/registrations'
    }
  end
  # get 'welcome/index'
  root 'admin/orders#index'


  resources :users do
    put '/change_status/:status' => 'users#change_status', as: 'change_status'
  end

  # Configuring routes under Admin namespace
  resources :item_prices
  namespace :admin do
    resources :orders, path: '' do
      collection do
        get 'list_of_orders_without_service_provider', as: 'assign_service_provider'
        get 'list_of_orders_without_logistic', as: 'assign_logistic'
        put 'assign_service_provider_to_order'
        put 'assign_logistic_to_order'
      end
    end
    resources :customers do
      member do
        put 'add_funds_to_wallet', as: 'add_funds'
        # put 'change_status/:status'
      end
      collection do
        get 'list_of_customers', as: 'list_of'
      end
    end
    resources :service_providers do
      collection do
        get 'list_of_service_providers', as: 'list_of'
      end
    end
    resources :logistics do
      collection do
        get 'list_of_logistics', as: 'list_of'
      end
    end
    resources :service_types do
      collection do
        get 'list_of_service_types', as: 'list_of'
      end
    end
    resources :items do
      collection do
        get 'list_of_items', as: 'list_of'
      end
    end
    resources :wallets, only: [:show]
    resources :complaints do
      collection do
        get 'list_of_complaints', as: 'list_of'
      end

      member do
        post 'add_message'
      end
    end

  end

  resources :notifications, only: [:index]


  # The priority is based upon order of creation: first created -> highest
  # priority.
  # See how all your routes lay out with 'rake routes'.

  # You can have the root of your site routed with 'root'
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically)
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
