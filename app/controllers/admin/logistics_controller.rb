class Admin::LogisticsController < ApplicationController
  before_action :authenticate_user!

  def list_of_logistics
    @logistics = Logistic.all
  end


  def logistic_params
    params.require(:service_provider).permit(:first_name, :last_name, :email, :mobile, :avatar)
  end
end
