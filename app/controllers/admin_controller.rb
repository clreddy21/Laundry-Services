class AdminController < ApplicationController
  before_action :authenticate_user!

  def customers
    @customers = Customer.all
  end

  def categories
    @categories = Category.all
  end
end
