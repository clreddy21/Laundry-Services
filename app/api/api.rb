class API < Grape::API
  prefix 'api'
  version 'v1', using: :path
  mount Users::Login
  mount Users::Signup
  mount Customers::ServiceProviders
  mount Customers::Orders
end