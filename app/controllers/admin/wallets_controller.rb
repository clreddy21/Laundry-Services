class Admin::WalletsController < ApplicationController
  def show
    @user = User.includes(:wallet, :transactions).find(params[:id])
    @transactions = @user.transactions.by_id
  end
end