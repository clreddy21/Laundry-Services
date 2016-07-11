class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
before_action :check_if_admin, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def check_if_admin
    user = User.find_by(email: params[:user][:login])

    if user.nil?
      redirect_to :back, notice: 'This email is not registered with us. Please correct and try again.'
    elsif user.type != 'Admin'
      redirect_to :back, notice: 'This login is only for admin.'
    end
  end
end
