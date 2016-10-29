class AdminController < ApplicationController
  before_action :authenticate_user!

  def customers
    @customers = Customer.by_id
  end

  def service_providers
    @service_providers = ServiceProvider.by_id
  end

  def logistics
    @logistics = Logistic.by_id
  end

  def items
    @items = Item.by_id
  end

  def service_types
    @service_types = ServiceType.by_id
  end
end
