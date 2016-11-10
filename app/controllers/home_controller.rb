class HomeController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :go_home]
  before_action :is_user?

  def index
    @celebs = User.all_non_deleted_celebrities
    @verified = Celebrity.where(:verified_account => true).limit(7)
  end

  def go_home
    celebs = User.all_non_deleted_celebrities
    verified = Celebrity.where(:verified_account => true).limit(7)
    render :partial => "home", :locals => {:@celebs => celebs, :@verified => verified}
  end


  private

  def is_user?
    #sign_out(current_user) if current_user.present?
    if user_signed_in?
      if current_user.is_user
        return true
      else
        redirect_to :controller => "admin/home", action: "index"
      end
    #else
      #redirect_to "/"
    end
  end


end
