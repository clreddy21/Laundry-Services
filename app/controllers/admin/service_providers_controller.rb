class Admin::ServiceProvidersController < ApplicationController
  before_action :authenticate_user!

  def list_of_service_providers
    @service_providers = ServiceProvider.all
  end

  def new
    @service_provider = ServiceProvider.new
  end

  def show
    @service_provider = ServiceProvider.find(params[:id])
  end

  def edit
    @service_provider = ServiceProvider.find(params[:id])
  end

  def create
    service_provider = ServiceProvider.create(service_provider_params)
    if service_provider.save!
      redirect_to list_of_admin_service_providers_path, notice: 'Service Provider added successfully.'
    else
      redirect_to new_admin_service_provider_path, notice: 'Failed to add Service Provider, please try again.'
    end
  end

  def update
    service_provider = ServiceProvider.find(params[:id])
    service_provider.update(service_provider_params)
    if service_provider.save!
      redirect_to admin_service_provider_path(service_provider), notice: 'Service Provider updated successfully.'
    else
      redirect_to :back, notice: 'Failed to update Service Provider, please try again.'
    end
  end

  def service_provider_params
    params.require(:service_provider).permit(:first_name, :last_name, :email, :mobile, :average_review,
     :reviews_count, :avatar).merge(password: 'testtest1', :password_confirmation => 'testtest1')
  end

end