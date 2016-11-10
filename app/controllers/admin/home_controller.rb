class Admin::HomeController < ApplicationController

  # before_action :authenticate_user!, :except => [:index]
  # before_action :user_admin?
  layout "admin"

  def index
    @user_count = User.where(:user_type => "user").count
    @celeb_count = User.where(:user_type => "celebrity").count
    if user_signed_in?
      render 'admin_index' if current_user.admin?
    else
      render "/users/admin_sign_in"
    end
  end

  def dashboard
  end

  private

  def user_admin?
    if user_signed_in?
      if current_user.admin?
        return true
      else
        redirect_to "/home/index"
      end
    else
      redirect_to "/users/admin_sign_in"
    end
  end


end
