class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_current_user


  def edit_profile
    @edit = true
    @user = User.find_by(id: params[:user_id])
  end


  def update_profile

    user = User.find_by(id: params[:user_id]).type.downcase
    old_password = params[user][:current_password]
    new_password = params[user][:password]
    confirm_password = params[user][:password_confirmation]

    if (old_password == '' || new_password == '' || confirm_password == '')
      redirect_to :back,:alert => 'Please fill all the fields'
    else
      if new_password.strip.length > 5 && new_password.strip.length < 72
        if current_user.valid_password?(old_password)
          if new_password == confirm_password
            @user = current_user
            current_user.update(password: new_password)
            sign_in @user, :bypass => true
            # raise current_user.inspect
            redirect_to :root, :notice => 'Password updated successfully'
          else
            redirect_to :back, :alert => 'New and confirm password did not match'
          end
        else
          redirect_to :back, :alert => 'Incorrect Old Password'
        end
      else
        redirect_to :back, :alert => 'Password should be atleast 6 charecters'
      end
    end
  end

  def check_current_user
    user = User.find_by(id: params[:user_id])
    if user == current_user
    else
      redirect_to root_path
    end
  end


  def change_status
    # raise params.inspect
    user = User.find_by(id: params[:user_id])
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
