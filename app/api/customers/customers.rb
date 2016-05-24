module Customers
  class ServiceProviders < Grape::API
    resource :get_service_providers do
      desc "Get service providers depending upon distance and service provided"
      params do
        requires :latitude, type:String
        requires :longitude, type:String
        requires :distance, type:Integer
        requires :service_type, type:String
      end
      # This gets service providers in the specified distance and service type
      get do
        service_providers = ServiceType.includes(:service_provider).where(:params[:service_type] => true).collect(ServiceProvider)
        service_providers = service_providers.where
      end

    end
  end
end