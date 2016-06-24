class Admin::LogisticsController < ApplicationController
  before_action :authenticate_user!

  def list_of_logistics
    @logistics = Logistic.all
  end

  def new
    @logistic = Logistic.new
  end

  def show
    @logistic = Logistic.includes(:orders).find(params[:id])
    @amount = @customer.orders.pluck(:total_cost).sum
  end

  def edit
    @logistic = Logistic.find(params[:id])
  end

  def create
    logistic = Logistic.create(logistic_params)
    if logistic.save!
      redirect_to list_of_admin_logistics_path, notice: 'Logistic added successfully.'
    else
      redirect_to new_admin_logistic_path, notice: 'Failed to add Logistic, please try again.'
    end
  end

  def update
    logistic = Logistic.find(params[:id])
    logistic.update(logistic_params)
    if logistic.save!
      redirect_to admin_logistic_path(logistic), notice: 'Logistic updated successfully.'
    else
      redirect_to :back, notice: 'Failed to update Logistic, please try again.'
    end
  end


  def logistic_params
    params.require(:logistic).permit(:first_name, :last_name, :email, :mobile, :avatar).merge(password: 'testtest1', :password_confirmation => 'testtest1')
  end
end
