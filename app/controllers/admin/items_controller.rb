class Admin::ItemsController < ApplicationController
  before_action :authenticate_user!

  def list_of_items
    @items = Item.all.by_id
    @item = Item.new
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    # raise params.inspect
    item = Item.create(name: params[:item][:name], avatar: params[:item][:avatar])

    if item.save!
      redirect_to list_of_admin_items_path, notice: 'Item added successfully.'
    else
      redirect_to new_admin_item_path, notice: 'Failed to create item, please try again.'
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save!
      redirect_to list_of_admin_items_path, notice: 'Item updated successfully.'
    else
      redirect_to :back, notice: 'Failed to update item, please try again.'
    end
  end

  def deactivate
    item = Item.find(params[:item_id])
    item.update(is_active: false)
    if item.save!
      redirect_to list_of_admin_items_path, notice: 'Item deactivated successfully.'
    else
      redirect_to :back, notice: 'Failed to deactivate item, please try again.'
    end
  end

  def activate
    item = Item.find(params[:item_id])
    item.update(is_active: true)
    if item.save!
      redirect_to list_of_admin_items_path, notice: 'Item activated successfully.'
    else
      redirect_to :back, notice: 'Failed to activate item, please try again.'
    end
  end

  def item_params
    params.require(:item).permit(:name, :avatar)
  end


end
