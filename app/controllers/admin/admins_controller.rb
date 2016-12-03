require 'securerandom'

class Admin::AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner


  def new
    @admin = Admin.new
  end

  def list_of_admins
    @admins = Admin.all
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def create
    password = 	SecureRandom.hex(3)
    admin = Admin.create(first_name: params[:first_name], last_name: params[:last_name], email: params[:email],
                               mobile: params[:mobile], password: password, status: 'active', level: 'Moderator')
    if admin.save!
      Address.create(address: params[:address], addressable: logistic)
      redirect_to list_of_admin_admin_path, notice: 'Moderator added successfully.'
    else
      redirect_to new_admin_admin_path, notice: 'Failed to add Moderator, please try again.'
    end
  end

  def update
    admin = Admin.find(params[:id])
    admin.update(admin_params)
    if admin.save!
      redirect_to admin_admin_path(admin), notice: 'Moderator updated successfully.'
    else
      redirect_to :back, notice: 'Failed to update Moderator, please try again.'
    end
  end


  def admin_params
    params.require(:admin).permit(:first_name, :last_name, :email, :mobile, :avatar).merge(password: 'testtest1', :password_confirmation => 'testtest1')
  end

  def check_owner
    if current_user.level == "Owner"
    else
      redirect_to :back, notice: 'Invalid Path.'
    end
  end
end
