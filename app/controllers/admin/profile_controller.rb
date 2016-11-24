class Admin::ProfileController < ApplicationController

  layout "admin"
  def index

    # @users = User.all_non_deleted_users
    @profile = Profile.all

  end

  def destroy
    @profile = Profile.find(params[:id])
    if @profile.destroy
      redirect_to :controller => "admin/profile", :action => "index"
      flash[:success] = "User Profile has been Deleted successfully"

    else
      redirect_to :controller => "admin/profile", :action => "index"
      flash[:notice] = "User Profile has not been Deleted successfully"

    end
  end

  def active_deactive_profile
    @profile = Profile.find(params[:id])
    if @profile.is_approved == false
      @profile.update_attributes(:is_approved => true)
      flash[:notice] = "User Profile Success fully Approved"
      render :text => "active"
    else
      @profile.update_attributes(:is_approved => false)
      flash[:notice] = "User Profile Has  been Rejected"
      render :text => "deactive"
    end
  end


  # def new
  #
  # end
  #
  #
  # def create
  #   puts 'ssssssssssssssssssss', user_params.inspect
    # @user = User.new(profile_params)
    # if @user.sav
    #   if create_customer_on_braintree(@user)
    #     flash[:success] = "User has been created successfully"
    #     render :text => "ok"
    #   else
    #     puts "---------brain tree ustomer create error-----------", result.errors
        # @user.destroy
        # flash[:notice] = "Some fields are missing while creating user"
        # render :text => "not ok"
      # end
    # else
    #   flash[:notice] = "Some fields are missing while creating user"
    #   render :text => "not ok"
    # end
  # end
  #
  # def all_users
  #   @users = User.all_non_deleted_users
  # end
  #
  def show
  @profile = Profile.find(params[:id])
  end
  #
  # def edit
  #   @user = User.find(params[:id])
  # end
  #
  # def update
  #   puts "0000000000000000000000000000000",params.inspect
  #
  #   @user = User.find(params[:user_id])
  #   puts "11111111111111111111111111111",@user.inspect
  #   if @user.update_attributes!(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password])
  #     flash[:success] = "User has been Updated successfully"
  #     render :text => "ok"
  #   else
  #     flash[:notice] = "Some fields are missing while updating user"
  #     render :text => "not ok"
  #   end

  # end
  #
  # def destroy
  #   @user = User.find(params[:id])
  #   if @user.destroy
  #     redirect_to :controller => "admin/users", :action => "all_users"
  #   else
  #     redirect_to :controller => "admin/users", :action => "all_users"
  #   end
  # end
  #
  # def active_deactive_profile
  #   @user = User.find(params[:id])
  #   if @user.is_active == false
  #     @user.update_attributes(:is_active => true)
  #     flash[:notice] = "User Success fully activated"
  #     render :text => "active"
  #   else
  #     @user.update_attributes(:is_active => false)
  #     flash[:notice] = "User Success fully DeActivated"
  #     render :text => "deactive"
  #   end
  # end
  #
  #
  # private
  # def profile_params
  #   params.require(:user).permit(:first_name, :email, :password, :password_confirmation, :last_name, :is_active, :user_type) #, :profile_attributes => [:about_yourself, :gender, :phone_number,:distance])
  # end
  #

end
