class Admin::UsersController < ApplicationController
  layout "admin"

  def add_user

  end

  def new

  end


  def create_user
    # puts 'ssssssssssssssssssss', user_params.inspect
    @user = User.new(user_params)
    if @user.save
      if create_customer_on_braintree(@user)
        flash[:success] = "User has been created successfully"
        render :text => "ok"
      else
        # puts "---------brain tree ustomer create error-----------", result.errors
        @user.destroy
        flash[:notice] = "Some fields are missing while creating user"
        render :text => "not ok"
      end
    else
      flash[:notice] = "Some fields are missing while creating user"
      render :text => "not ok"
    end
  end

  def all_users
    @users = User.all_non_deleted_users
  end

  def show_user

  end

  def edit
    @user = User.find(params[:id])
  end

  def update_user
    @user = User.find(params[:user_id])
    if @user.update_attributes(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password])
      flash[:success] = "User has been Updated successfully"
      render :text => "ok"
    else
      flash[:notice] = "Some fields are missing while updating user"
      render :text => "not ok"
    end

  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to :controller => "admin/users", :action => "all_users"
    else
      redirect_to :controller => "admin/users", :action => "all_users"
    end
  end

  def active_deactive_user
    @user = User.find(params[:id])
    if @user.is_active == false
      @user.update_attributes(:is_active => true)
      flash[:notice] = "User Success fully Dectivated"
      render :text => "deactive"
    else
      @user.update_attributes(:is_active => false)
      flash[:notice] = "User Success fully Activated"
      render :text => "active"
    end
  end


  private
  def user_params
    params.require(:user).permit(:first_name, :email, :password, :password_confirmation, :last_name, :is_active, :user_type) #, :profile_attributes => [:about_yourself, :gender, :phone_number,:distance])
  end


end
