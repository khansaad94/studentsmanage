class Admin::PaymentAddressesController < ApplicationController
  layout "admin"
  def index
   @cel_users =  User.all_cel_users
  end
end
