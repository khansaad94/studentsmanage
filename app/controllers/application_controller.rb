class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_filter :authenticate_user!
  before_action :route_user


  def route_user


    current_uri = request.env['PATH_INFO']
    if current_uri.include? "/admin"
      if current_uri.include? "/admin_sign_in"

      else
        if user_signed_in?
          if current_user.admin?

          else
            redirect_to '/'
          end
        else
          redirect_to "/users/admin_sign_in"
        end
      end
    else
      #if user_signed_in?
      #  if current_user.admin?
      #    if (current_uri.include? "/users/admin_sign_in") || (current_uri.include? "/users/sign_out")
      #    else
      #      redirect_to "/admin/home/index"
      #    end
      #  end
      #end
    end
    # puts "sssssssssssssss", current_uri.inspect

  end

  def create_customer_on_braintree(user)
    result = Braintree::Customer.create(
        :first_name => user.first_name.present? ? user.first_name : "",
        :last_name => user.last_name.present? ? user.last_name : "",
        :email => user.email
    )
    if result.success?
      user.update_attributes(:customer_id => result.customer.id)
      return true
    else
      return false
    end
  end


  def create_merchant_on_braintree(user, acc_num, rout_num,ssn)
    result = Braintree::MerchantAccount.create(
        :individual => {
            :first_name => user.first_name,
            :last_name => user.last_name,
            :email => user.email,
            :date_of_birth => '2014-01-01',
            :ssn => ssn.present? ? ssn : "",
            :address => {
                :street_address => user.street_address,
                :locality => user.city,
                :region => user.state,
                :postal_code => user.zip_code
            }
        },
        :funding => {
            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
            :account_number => acc_num,
            :routing_number => rout_num
        },
        :tos_accepted => true,
        :master_merchant_account_id => "ycdtqqj2qjby6wgt"
    )
    if result.success?
      if user.update_attribute(:merchant_id, result.merchant_account.id)
        return true
      else
        return true
      end
    else
      flash[:danger] = result.message
      return false
    end
  end

  def update_merchant_on_braintree(user, acc_num, rout_num,ssn)
    result = Braintree::MerchantAccount.update(
        user.merchant_id,
        :individual => {
            :first_name => user.first_name,
            :last_name => user.last_name,
            :email => user.email,
            :date_of_birth => '1981-11-19',
            :ssn => ssn.present? ? ssn : "",
            :address => {
                :street_address => user.street_address,
                :locality => user.city,
                :region => user.state,
                :postal_code => user.zip_code
            }
        },
        :funding => {
            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
            :account_number => acc_num,
            :routing_number => rout_num
        },
    )
    if result.success?

      if user.update_attribute(:merchant_id, result.merchant_account.id)
        return true
      else
        return true
      end
    else
      flash[:danger] = result.message
      return false
    end
  end


  def send_push_notification_to_celebrity(user, message)
    #this is the main function
    if user.device_token.blank?
      return
    end
    notification = Houston::Notification.new(device: user.device_token)
    notification.sound = "sosumi.aiff"
    notification.content_available = true
    notification.custom_data = {:user_id => user.id, :first_name => user.first_name, :full_name => user.full_name}
    notification.alert = "#{user.full_name} : #{message}"
    # certificate = File.read("config/celebvidydevelopment.pem") if Rails.env == "development"
    #certificate = File.read("config/ck_production.pem") if Rails.env == "production"
    certificate = File.read("config/celebvidyproduction.pem") if Rails.env == "production"
    pass_phrase = "push"
    connection = Houston::Connection.new("apn://gateway.push.apple.com:2195", certificate, pass_phrase)
    #connection = Houston::Connection.new("apn://gateway.push.apple.com:2195", certificate, pass_phrase)
    connection.open
    connection.write(notification.message)
    connection.close
    puts "notification sent to user #{user.full_name} and device token is #{user.device_token}"
  end

  def send_push_notification_to_user(user, message)
    #this is the main function
    if user.device_token.blank?
      puts "........................Device token not present............................"
      return
    end
    puts "////////////////////////////////////////////////"
    notification = Houston::Notification.new(device: user.device_token)
    notification.sound = "sosumi.aiff"
    notification.content_available = true
    notification.custom_data = {:user_id => user.id, :first_name => user.first_name, :full_name => user.full_name}
    notification.alert = "#{user.full_name} : #{message}"
    #certificate = File.read("config/celebvidydevelopment.pem") if Rails.env == "development"
    certificate = File.read("config/celebuserProduction.pem") if Rails.env == "production"
    pass_phrase = "push"
    connection = Houston::Connection.new("apn://gateway.push.apple.com:2195", certificate, pass_phrase)
    #connection = Houston::Connection.new("apn://gateway.push.apple.com:2195", certificate, pass_phrase)
    connection.open
    connection.write(notification.message)
    connection.close
    puts "notification sent to user #{user.full_name} and device token is #{user.device_token}"
  end


#after_filter :store_location

 #def store_location
 #  # store last url - this is needed for post-login redirect to whatever the user last visited.
 #  return unless request.get?
 #  if (request.path != "/users/sign_in" &&
 #      request.path != "/users/sign_up" &&
 #      request.path != "/users/password/new" &&
 #      request.path != "/users/password/edit" &&
 #      request.path != "/users/confirmation" &&
 #      request.path != "/users/sign_out" &&
 #      !request.xhr?) # don't store ajax calls
 #    session[:previous_url] = request.fullpath
 #  end
 #end

 def after_sign_in_path_for(resource)
   session[:url] || root_path
   end
end
