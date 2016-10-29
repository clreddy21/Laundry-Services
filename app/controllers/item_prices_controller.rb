class ItemPricesController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :json


  def index
    @admin_sp = User.find_by(email: 'admin_sp@ls.com')
    @item_prices = @admin_sp.item_prices.by_id
    service_type_ids = ItemPrice.all.pluck(:service_type_id).uniq

    @service_types =  ServiceType.where(id: service_type_ids)
    @items =  Item.where(id: ItemPrice.all.pluck(:item_id).uniq)
    @item_price = ItemPrice.new
  end

  def new
    @item_price = ItemPrice.new
  end

  def edit
    @item_price = ItemPrice.find(params[:id])
  end

  def create
    item_price = ItemPrice.create(item_price_params)
    if item_price.save!
      redirect_to list_of_admin_item_prices_path, notice: 'Item Price added successfully.'
    else
      redirect_to new_admin_item_prices_path, notice: 'Failed to create item price, please try again.'
    end
  end

  def update
    @item_price = ItemPrice.find(params[:id])
    @item_price.update(price: params[:item_price][:price])
    if @item_price.save!
      respond_with @item_price
      # redirect_to list_of_admin_item_prices_path, notice: 'Item Price updated successfully.'
    else
      redirect_to :back, notice: 'Failed to update item, please try again.'
    end
  end

  def item_params
    params.require(:item).permit(:name)
  end


end
