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
        service_providers.near([params[:latitude], params[:longitude]], params[:distance], :units => :km)    # venues within 20 miles of a point
      end
    end
  end
end