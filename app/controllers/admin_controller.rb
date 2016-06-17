class AdminController < ApplicationController
  before_action :authenticate_user!

  def customers
    @customers = Customer.all
  end

  def service_providers
    @service_providers = ServiceProvider.all
  end

  def logistics
    @logistics = Logistic.all
  end

  def items
    @items = Item.all
  end

  def service_types
    @service_types = ServiceType.all
  end
end
