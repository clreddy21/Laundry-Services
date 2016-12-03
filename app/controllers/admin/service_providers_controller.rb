class Admin::ServiceProvidersController < ApplicationController
  before_action :authenticate_user!

  def list_of_service_providers
    @service_providers = ServiceProvider.all.by_id
  end

  def new
    @service_provider = ServiceProvider.new
  end

  def show
    @service_provider = ServiceProvider.find(params[:id])
    @orders = @service_provider.orders.includes(:customer, :logistic)
    @amount = @orders.pluck(:total_cost).sum
  end

  def edit
    @service_provider = ServiceProvider.find(params[:id])
  end

  def create
    user = User.find_by(:email => params[:service_provider][:email])
    if user.present?
      redirect_to new_admin_service_provider_path, notice: 'The given mail id is already used, please try again.'
    else
      service_provider = ServiceProvider.create(service_provider_params)
      if service_provider.save!
        Address.create(address: params[:address], :addressable  => service_provider)
        service_provider.build_item_prices
        redirect_to list_of_admin_service_providers_path, notice: 'Service Provider added successfully.'
      else
        redirect_to new_admin_service_provider_path, notice: 'Failed to add Service Provider, please try again.'
      end
    end
  end

  def update
    service_provider = ServiceProvider.find(params[:id])
    service_provider.update(service_provider_params)
    service_provider.addresses.last.update(address: params[:address])
    if service_provider.save!
      redirect_to admin_service_provider_path(service_provider), notice: 'Service Provider updated successfully.'
    else
      redirect_to :back, notice: 'Failed to update Service Provider, please try again.'
    end
  end

  def service_provider_params
    params.require(:service_provider).permit(:first_name, :last_name, :email, :mobile, :average_review,
     :reviews_count, :avatar, :shop_name, :experience, :capacity, :max_workload, :open_time, :close_time,
     :is_partner, :is_open_on_sunday).merge(password: 'testtest1', :password_confirmation => 'testtest1', status: 'active')
  end

end