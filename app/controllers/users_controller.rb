class UsersController < ApplicationController
  skip_before_action :require_login
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      begin
        ActiveRecord::Base.transaction do
          @user.create_default_preset
          redirect_to login_path, notice: t('.success')
        end
      rescue 
        redirect_to login_path, notice: t('.missing_create_default_preset')
      end
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end
