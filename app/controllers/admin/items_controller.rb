class Admin::ItemsController < ApplicationController
  before_action :authenticate_user!

  def list_of_items
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    item = Item.create(item_params)
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

  def item_params
    params.require(:item).permit(:name)
  end


end
