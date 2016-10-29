class Admin::ServiceTypesController < ApplicationController
  before_action :authenticate_user!

  def list_of_service_types
    @service_types = ServiceType.all.by_id
    @service_type = ServiceType.new
  end


  def new
    @service_type = ServiceType.new
  end

  def edit
    @service_type = ServiceType.find(params[:id])
  end

  def create
    service_type = ServiceType.create(name: params[:name])
    if service_type.save!
      redirect_to list_of_admin_service_types_path, notice: 'service type added successfully.'
    else
      redirect_to new_admin_service_type_path, notice: 'Failed to create service type, please try again.'
    end
  end

  def update
    service_type = ServiceType.find(params[:id])
    service_type.update(service_type_params)
    if service_type.save!
      redirect_to list_of_admin_service_types_path, notice: 'Service type updated successfully.'
    else
      redirect_to :back, notice: 'Failed to update Service_type, please try again.'
    end
  end

  def service_type_params
    params.require(:service_type).permit(:name)
  end

end
