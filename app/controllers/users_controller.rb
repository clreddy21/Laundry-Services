class UsersController < ApplicationController
  before_action :authenticate_user!

  def change_status
    # raise params.inspect
    user = User.find_by(params[:user_id])
    if params[:status] == 'Blacklist'
      user.update(status: 'balcklisted')
    elsif params[:status] == 'Suspend'
      user.update(status: 'suspended')
    elsif params[:status] == 'Activate'
      user.update(status: 'active')
    end
    user.save!
    # raise user.inspect
    message = "User status has been changed to #{user.status}"
    redirect_to :back, notice: message
  end

end
