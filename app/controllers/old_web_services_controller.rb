#class WebServicesController < ApplicationController
#
#  skip_before_filter :authenticate_user!
#  before_filter :check_session_create, :except => [:forgot_password, :add_payment_and_create_job, :user_sign_up, :user_sign_up_facebook, :forgot_password,:test_function,:test_service]
#  skip_before_filter :verify_authenticity_token
#  #require 'json_builder'
#  respond_to :json, :html
#
#  def aindex
#  end
#
#  def auser_sign_up_facebook
#    #localhost:3000/web_services/user_sign_up_facebook?[user][first_name]=first&[user][last_name]=last&[user][email]=asad.rehman@whiterabbit.is&[user][password]=12345678&[user][user_type]=user&[facebook_id]=9876543210
#    puts "+++++++++++++++++++facebook_sign_up+++++++++++++++++++"
#    puts "000000000000000000000", params.inspect
#    begin
#      if request.format(request) == '*/*'
#        if params[:facebook_id].present?
#          @user = User.where(:facebook_id => params[:facebook_id]).first
#          if @user.present?
#            render :json => {:success => "true", :message => "signed in successfully", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,  :token => @user.session_token }}
#            @user.update_attributes(:sign_in_count => @user.sign_in_count + 1, :device_token => params[:user][:device_token])
#          else
#            random_str = SecureRandom.hex
#            @user = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password],:user_type => params[:user][:user_type], :facebook_id => params[:facebook_id], :device_token => params[:user][:device_token], :session_token => random_str)
#            if @user.save
#              create_customer_on_braintree(@user)
#              #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
#              #create_customer_to_braintree(@user)
#              render :json => {:success => "true", :message => "user has been successfully created", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token }}
#              @user.update_attributes(:sign_in_count => @user.sign_in_count + 1)
#            else
#              render :json => {:success => "false", :message => "cant create user"}
#            end
#          end
#        else
#          render :json => {:success => "false", :message => "cant create user facebook id does not exist"}
#        end
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#
#  def auser_sign_up(email, password,device_token)
#    #localhost:3000/web_services/user_sign_up?[user][first_name]=first&[user][last_name]=last&[user][email]=tahir.khan@whiterabbit.is&[user][password]=12345678&[user][user_type]=user
#    puts "+++++++++++++++++++sign_up+++++++++++++++++++"
#    puts "000000000000000000000", params.inspect
#    begin
#      unless email.blank? || password.blank?
#        @already_user = User.where(:email => email).first
#        if @already_user.blank?
#          random_str = SecureRandom.hex
#          @user = User.new(:email => email, :password => password,:user_type => "user", :device_token => device_token, :session_token => random_str)
#          if @user.save
#            create_customer_on_braintree(@user)
#            add_credit_card_payment_method(cvv,credit_card_number,expiration_date,cardholder_name,@user)
#            #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
#            #create_customer_to_braintree(@user)
#            render :json => {:success => "true", :message => "user has been successfully created", :user => {:id => @user.id,:first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token}}
#          else
#            render :json => {:success => "false", :message => "cant create user"}
#          end
#        else
#          render :json => {:success => "false", :message => "email already exists"}
#        end
#      else
#        render :json => {:success => "false", :message => "both email and password are required to sign up"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def aupdate_password
#
#    puts "_________________________update_password_________________________"
#    puts "000000000000000000000", params.inspect
#    begin
#      if @user.valid_password?(params[:user][:current_password])
#        @user.update_attributes(:password => params[:user][:new_password])
#        render :json => {:success => "true", :message => "Matched, password changed successfully"}
#      else
#        render :json => {:success => "false", :message => "your password does not match varification"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def aforgot_password
#    @user = User.find(4)
#    puts "_________________________forgot_password_________________________"
#    puts "000000000000000000000", params.inspect
#    #params[:email] = "tahir.khan@whiterabbit.is"
#    begin
#      #@user = User.where(:email => params[:user][:email]).first
#      puts "------------@user.inspect-----------------", @user.inspect
#      unless @user.blank?
#        @user = User.send_reset_password_instructions(@user)
#        render :json => {:success => "true", :message => "email successfully send"}
#      else
#        render :json => {:success => "false", :message => "User is not registered with this email,Invalid Email"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#
#  def aget_all_celebrities
#    begin
#      @celebrity_users = User.all_non_deleted_celebrities#.all.where(:user_type => "celebrity")
#      celebrity_array = []
#      @celebrity_users.each do |user|
#        celebrity_array << {:id => user.id,:first_name => user.first_name, :last_name => user.last_name, :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "" }
#      end
#                                                         #@sub_categories = Category.where(:parent_id => nil)
#      unless celebrity_array.blank?
#        render :json => {:success => "true", :celebrity_array => celebrity_array}
#      else
#        render :json => {:success => "false", :message => "No record found, Celebrities does not exists"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#  def aget_celebrity_profile
#    begin
#      #params[:user_id] = "3"
#      @celebrity_user = User.find_celeb(params[:user_id])
#      unless @celebrity_user.blank?
#        render :json => {:success => "true", :message => "successfully get celebrity",:id => @celebrity_user.id,:first_name => @celebrity_user.first_name, :last_name => @celebrity_user.last_name, :about_me => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.about_me : "", :description => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.description : "", :default_rate => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.default_rate : "",:url => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.avatar.url : "" }
#      else
#        render :json => {:success => "false", :message => "No record found, Celebrities does not exists"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def asearch_celebrity_by_name_or_industry
#    begin
#      #params[:search_name] = "cele"
#      all_celebrities = []
#      if params[:search_name].present?
#        @celebrity_users = User.search_celeb_by_name_or_industry(params[:search_name]) #.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
#        unless @celebrity_users.blank?
#          @celebrity_users.each do |user|
#            all_celebrities << {:id => user.id,:first_name => user.first_name, :last_name => user.last_name, :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : ""}
#          end
#          return render :json => {:success => "true", :all_celebrities => all_celebrities}
#        else
#          return render :json => {:success => "false", :message => "No Record Found!...", :all_celebrities => all_celebrities}
#        end
#      else
#        return render :json => {:success => "false", :message => "Missings Params,search params does not exist"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#  def asearch_filtered_celebrities
#    begin
#      #params[:price] = "200"
#      all_celebrities = []
#      if params[:price].present?
#        @celebrity_users = User.all_non_deleted_celebrities#.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
#        unless @celebrity_users.blank?
#          @celebrity_users.each do |user|
#            if (user.celebrity.default_rate == params[:price].to_f)
#              all_celebrities << {:id => user.id,:first_name => user.first_name, :last_name => user.last_name, :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : ""}
#            end
#          end
#          return render :json => {:success => "true", :all_celebrities => all_celebrities}
#        else
#          return render :json => {:success => "false", :message => "No Record Found!...", :all_celebrities => all_celebrities}
#        end
#      else
#        return render :json => {:success => "false", :message => "Missings Params,search params does not exist"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#  def aadd_payment_and_create_job
#    begin
#      params[:message_for] = "adeel"
#      params[:pronounce_like] = "ad-eel"
#      params[:event_type_id] = 1
#      params[:message_details] = "hi adeel happy birthday"
#      params[:celebrity_id] = 5
#      params[:is_gift] = 1
#      if @user.present?
#        @user_job = Job.new(:message_for => params[:message_for], :pronounce_like => params[:pronounce_like],:is_gift => params[:is_gift], :event_type_id => params[:event_type_id],:message_details => params[:message_details],:deadline => params[:deadline],:status => "pending", :celebrity_id=> params[:celebrity_id],:user_id => @user.id, :customer_job_id => @user.first_name+@user.last_name+rand(99999).to_s)
#        if @user_job.save
#          render :json => {:success => "true", :errors => "job successfully created", :user_job => @user_job}
#        else
#          render :json => {:success => "true", :errors => "Error, Some thing missing in create job"}
#        end
#      else
#        render :json => {:success => "false", :errors => "authentication failed.."}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def aadd_credit_card_payment_method(cvv,credit_card_number,expiration_date,cardholder_name,user)
#    puts "_________________________add_credit_card_payment_method_________________________"
#    begin
#      #params[:cvv] = 123
#      #params[:credit_card_number] = "4005519200000004"
#      #params[:expiration_date] = "05/2020"
#      #params[:cardholder_name] = "tahir khan"
#      #4005519200000004
#      #4009348888881881
#      #4012000033330026
#      #4012000077777777
#      #4012888888881881
#      #4217651111111119
#      #4500600000000061
#      result = Braintree::CreditCard.create(
#          :customer_id => user.customer_id,
#          :cvv => cvv,
#          :number => credit_card_number,
#          :expiration_date => expiration_date,
#          :cardholder_name => cardholder_name,
#          :options => {
#              :verify_card => true,
#              :fail_on_duplicate_payment_method => true,
#              :make_default => true
#          }
#      )
#      if result.success?
#        puts "_________________________result.success?_________________________", result.inspect
#        @braintree_info = BraintreeInfo.create(:user_id => @user.id,:customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
#        #render :json => {:success => "true", :message => "Your Credit Card Has Been Successfully Added", :result => {:card_token => result.credit_card.token, :card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name, :type => result.credit_card.card_type, :expiration_month => result.credit_card.expiration_month, :expiration_year => result.credit_card.expiration_year}}
#      else
#        render :json => {:success => "false", :message => result.message} #errors.each{|a|a.message}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#  def afetch_customer_payment_methods
#    puts "_________________________fetch_customer_payment_methods_________________________"
#    puts "000000000000000000000", params.inspect
#    begin
#      if @user.customer_id.present?
#        customer = Braintree::Customer.find(@user.customer_id)
#        puts "111111111111111111111111111111111111", customer.inspect
#        cards_array = []
#        puts "222222222222222222222222222222222222", customer.credit_cards.inspect
#        customer.credit_cards.each do |a|
#          cards_array << {:card_token => a.token, :card_number => a.masked_number, :name => a.cardholder_name, :type => a.card_type, :expiration_month => a.expiration_month, :expiration_year => a.expiration_year}
#        end
#        if customer.present?
#          if customer.credit_cards.present?
#            render :json => {:success => "true", :message => "Your  Customer Has Been Successfully Fetched", :customer => cards_array}
#          else
#            render :json => {:success => "false", :message => "This customer does not have saved payment methods."}
#          end
#        else
#          render :json => {:success => "false", :message => "No Record Found On Braintree"}
#        end
#      else
#        render :json => {:success => "false", :message => "Braintree customer does not exists"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def aupdate_credit_card_payment_method
#    puts "_________________________update_credit_card_payment_method_________________________"
#    puts "000000000000000000000", params.inspect
#    #params[:card_token] = "6frcxg"
#    begin
#      params[:cvv] = 123
#      params[:credit_card_number] = "4009348888881881"
#      params[:expiration_date] = "05/2020"
#      params[:cardholder_name] = "tahir khan lodhi"
#      params[:card_token] = "k8t6hg"
#      if params[:card_token].present?
#        result = Braintree::CreditCard.update(
#            params[:card_token],
#            :number => params[:credit_card_number],
#            :expiration_date => params[:expiration_date],
#            :cvv => params[:cvv],
#            :cardholder_name => params[:cardholder_name],
#        )
#        #return render :json => {:success => "true", :message => "Card Updated Successfully",:result => {:card_token => result.credit_card.token,:card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name,:type => result.credit_card.card_type,:expiration_month => result.credit_card.expiration_month,:expiration_year => result.credit_card.expiration_year}}
#        if result.success?
#          puts "_________________________result.success?_________________________", result.inspect
#          braintree_information = BraintreeInfo.find_by_payment_method_token(params[:card_token])
#          braintree_information.update_attributes(:user_id => @user.id, :customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
#          render :json => {:success => "true", :message => "Your Credit Card Has Been Successfully Updated", :result => {:card_token => result.credit_card.token, :card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name, :type => result.credit_card.card_type, :expiration_month => result.credit_card.expiration_month, :expiration_year => result.credit_card.expiration_year}}
#        else
#          render :json => {:success => "false", :message => result.message} #errors.each{|a|a.message}
#        end
#      else
#        return render :json => {:success => result.to_s, :message => "Credit Card Token Not Present"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#
#  def acheck_session_create
#    params[:token] = "9a0ca3b42e0f7e1fdf198802299e75b8" if Rails.env == "development"
#    puts "_________________________check_session_create_________________________"
#    if params[:token].present?
#      @user = User.find_by_session_token(params[:token])
#      if @user.present?
#        puts "********user exists**********"
#        return true
#      else
#        puts "*********user does not exist************"
#        render :json => {:success => "false", :errors => " authentication failed.."}
#      end
#    else
#      puts "***********params token not present*************"
#      render :json => {:success => "false", :errors => " authentication failed.."}
#    end
#  end
#
#  def acreate_customer_on_braintree(user)
#    result = Braintree::Customer.create(
#        :first_name => user.first_name.present? ? user.first_name : "",
#        :last_name => user.last_name.present? ? user.last_name : "",
#        :email => user.email
#    )
#    puts "----------Brain tree result----------",result.inspect
#    if result.success?
#      user.update_attributes(:customer_id => result.customer.id)
#    else
#      puts "---------brain tree ustomer create error-----------", result.errors
#    end
#  end
#
#  def atest_service
#    return render :json => {:success => "true", :message => "Successfully"}
#  end
#
#
#  def acreate_transaction
#    result = Braintree::Transaction.sale(
#        :customer_id => @user.customer_id,
#        #:service_fee_amount => ApplicationHelper::CELEBVIDY_FEE,
#        #:merchant_account_id => merchant.merchant_id,
#        :amount => "100.0",
#        :payment_method_token => "jszxgw",
#        :options => {
#            :submit_for_settlement => true
#        }
#    )
#    if result.success?
#      #<Braintree::SuccessfulResult transaction:#<Braintree::Transaction id: "84q6n8",
#      # type: "sale",
#      # amount: "20.0",
#      # status: "submitted_for_settlement",
#      # created_at: 2015-02-03 14:01:35 UTC,
#      # credit_card_details: #<token: "hdn3j2",
#      # bin: "401288",
#      # last_4: "1881",
#      # card_type: "Visa",
#      # expiration_date: "05/2020",
#      # cardholder_name: "tahirkhanlodhi",
#      # customer_location: "US",
#      # prepaid: "No",
#      # healthcare: "Unknown",
#      # durbin_regulated: "Unknown",
#      # debit: "Unknown",
#      # commercial: "Unknown",
#      # payroll: "Unknown",
#      # country_of_issuance: "USA",
#      # issuing_bank: "Unknown">,
#      # customer_details: #<id: "81174133",
#      # first_name: "khan",
#      # last_name: "khan",
#      # email: "khan@yahoo.com",
#      # company: nil,
#      # website: nil,
#      # phone: "+923317612147",
#      # fax: nil>,
#      # subscription_details: #<Braintree::Transaction::SubscriptionDetails:0x007f2758b8e0d0 @billing_period_end_date=nil, @billing_period_start_date=nil>, updated_at: 2015-02-03 14:01:36 UTC>>
#      puts "yahuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu", result.inspect
#      @history = TransactionHistory.create(:transaction_id => result.transaction.id, :transaction_type => result.transaction.type, :status => result.transaction.status, :transaction_amount => '100', :merchant_id => "", :customer_id => @user.customer_id, :user_id => @user.id, :job_id => "")
#      render :json => {:success => "true",:message => "You have purchased' from  for $", :result => result.inspect}#, :result => result, :message => "You have purchased '#{pro.title.present? ? pro.title.to_s : ""}' from #{pro.user.present? ? pro.user.name : ""} for $ #{pro.price.present? ? pro.price.to_f : ""}"}
#    else
#      return render :json => {:success => "false", :message => "Not not Successful",:result => result.inspect}
#    end
#  end
#
#
#
#  def atest_function
#    begin
#      @user = User.find(3)
#      #create_customer_to_braintree(@user)
#      create_merchant_to_braintree("1123581321", "071101307")
#
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#
#  def aaadd_credit_card_payment_method
#    begin
#      #4005519200000004
#      #4009348888881881
#      #4012000033330026
#      #4012000077777777
#      #4012888888881881
#      #4217651111111119
#      #4500600000000061
#      #params[:credit_card_number] = "4005519200000004"
#      #params[:cardholder_name] = "tahirkhanlodhi"
#      #params[:expiration_date] = "05/2020"
#      result = Braintree::CreditCard.create(
#          :customer_id => '51440284',
#          :cvv => '123',
#          :number => '4500600000000061',
#          :expiration_date => '05/2025',
#          :cardholder_name => 'test',
#          :options => {
#              :verify_card => true,
#              :fail_on_duplicate_payment_method => true,
#              :make_default => true
#          }
#      )
#      if result.success?
#        puts "_________________________result.success?_________________________", result.inspect
#        render :json => {:success => "true", :message => "Your Credit Card Has Been Successfully Added", :result => {:card_token => result.credit_card.token, :card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name, :type => result.credit_card.card_type, :expiration_month => result.credit_card.expiration_month, :expiration_year => result.credit_card.expiration_year}}
#      else
#        render :json => {:success => "false", :message => result.message} #errors.each{|a|a.message}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#
#
#
#
#
#
#
#
#
#
#  #_______________________________________________________________________________________________________
#  #-------------------------------------------------------------------------------------------------------
#  #______________________________WEB SERVICES FOR CELEBRITIES_____________________________________________
#  #-------------------------------------------------------------------------------------------------------
#  #_______________________________________________________________________________________________________
#  def acelebrity_sign_up_facebook
#    #localhost:3000/web_services/user_sign_up_facebook?[user][first_name]=first&[user][last_name]=last&[user][email]=asad.rehman@whiterabbit.is&[user][password]=12345678&[user][user_type]=celebrity&[facebook_id]=9876543210
#    puts "+++++++++++++++++++facebook_sign_up+++++++++++++++++++"
#    puts "000000000000000000000", params.inspect
#    begin
#      if request.format(request) == '*/*'
#        if params[:facebook_id].present?
#          @user = User.where(:facebook_id => params[:facebook_id]).first
#          if @user.present?
#            render :json => {:success => "true", :message => "signed in successfully", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,  :token => @user.session_token }}
#            @user.update_attributes(:sign_in_count => @user.sign_in_count + 1, :device_token => params[:user][:device_token])
#          else
#            random_str = SecureRandom.hex
#            @user = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password],:user_type => params[:user][:user_type], :facebook_id => params[:facebook_id], :device_token => params[:user][:device_token], :session_token => random_str)
#            if @user.save
#              create_merchant_to_braintree("1123581321", "071101307")
#              #create_customer_on_braintree(@user)
#              #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
#              #create_customer_to_braintree(@user)
#              render :json => {:success => "true", :message => "celebrity has been successfully created", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token }}
#              @user.update_attributes(:sign_in_count => @user.sign_in_count + 1)
#            else
#              render :json => {:success => "false", :message => "cant create celebrity"}
#            end
#          end
#        else
#          render :json => {:success => "false", :message => "celebrity create user facebook id does not exist"}
#        end
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#
#  def acelebrity_sign_up
#    #localhost:3000/web_services/user_sign_up?[user][first_name]=first&[user][last_name]=last&[user][email]=tahir.khan@whiterabbit.is&[user][password]=12345678&[user][user_type]=celebrity
#    puts "+++++++++++++++++++sign_up+++++++++++++++++++"
#    puts "000000000000000000000", params.inspect
#    begin
#      unless params[:user][:email].blank? || params[:user][:password].blank?
#        @already_user = User.where(:email => params[:user][:email]).first
#        if @already_user.blank?
#          random_str = SecureRandom.hex
#          @user = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password],:user_type => params[:user][:user_type], :device_token => params[:user][:device_token], :session_token => random_str)
#          if @user.save
#            create_merchant_to_braintree("1123581321", "071101307")
#            #create_customer_on_braintree(@user)
#            #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
#            #create_customer_to_braintree(@user)
#            render :json => {:success => "true", :message => "celebrity has been successfully created", :user => {:id => @user.id,:first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token}}
#          else
#            render :json => {:success => "false", :message => "cant create celebrity"}
#          end
#        else
#          render :json => {:success => "false", :message => "email already exists"}
#        end
#      else
#        render :json => {:success => "false", :message => "both email and password are required to sign up"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def acreate_merchant_to_braintree(acc_num, rou_num)
#    puts "_________________________create_merchant_to_braintree(acc_num, rou_num,bank_name)---------------------"
#    puts "000000000000000000000", params.inspect
#    @result = Braintree::MerchantAccount.create(
#        :individual => {
#            :first_name => "Jane",
#            :last_name => "Doe",
#            :email => "celeb1@gmail.com",
#            :phone => "5553334444",
#            :date_of_birth => "2000-01-01",
#            #:ssn => "456-45-4567",
#            :address => {
#                :street_address => "111 Main St",
#                :locality => "chicago",
#                :region => "IL",
#                :postal_code => "60622"
#            }
#        },
#        :funding => {
#            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
#            :email => 'celeb1@gmail.com',
#            :mobile_phone => "5553334444",
#            :account_number => acc_num,
#            :routing_number => rou_num
#        },
#        :tos_accepted => true,
#        :master_merchant_account_id => "ycdtqqj2qjby6wgt"
#    )
#    if @result.success?
#      puts "------------add success @result", @result.inspect
#      puts "------------add success @result merchant_account.id", @result.merchant_account.id
#      render :json => {:success => "true", :message => @result.inspect }
#      #@user.merchant_id = @result.merchant_account.id
#      #if @user.update_attribute(:merchant_id, @result.merchant_account.id)
#      #  render :json => {:success => "true", :message => "Braintree account successfully created"}
#      #else
#      #  render :json => {:success => "false", :message => "User not Updated, merchant id not added"}
#      #end
#    else
#      msg ||= []
#      @result.errors.each { |error| msg << error.message }
#      render :json => {:success => "false", :message => "Something wrong, #{msg.join("\n")}"}
#    end
#
#  end
#
#
#  def acreate_merchant_on_braintree(acc_num, rou_num)
#    puts "_________________________create_merchant_to_braintree(acc_num, rou_num,bank_name)---------------------"
#    puts "000000000000000000000", params.inspect
#    @result = Braintree::MerchantAccount.create(
#        :individual => {
#            :first_name => @user.name,
#            :last_name => @user.name,
#            :email => @user.email,
#            :phone => @user.profile.phone_number,
#            :date_of_birth => "2000-01-01",
#            #:ssn => "456-45-4567",
#            :address => {
#                :street_address => @user.street_address,
#                :locality => @user.city,
#                :region => @user.state,
#                :postal_code => @user.zip_code
#            }
#        },
#        :funding => {
#            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
#            :email => @user.email,
#            :mobile_phone => @user.profile.phone_number,
#            :account_number => acc_num,
#            :routing_number => rou_num
#        },
#        :tos_accepted => true,
#        :master_merchant_account_id => "7yfqk2bwhgzspd35"
#    )
#    if @result.success?
#      puts "------------add success @result", @result.inspect
#      puts "------------add success @result merchant_account.id", @result.merchant_account.id
#      #@user.merchant_id = @result.merchant_account.id
#      if @user.update_attribute(:merchant_id, @result.merchant_account.id)
#        render :json => {:success => "true", :message => "Braintree account successfully created"}
#      else
#        render :json => {:success => "false", :message => "User not Updated, merchant id not added"}
#      end
#    else
#      msg ||= []
#      @result.errors.each { |error| msg << error.message }
#      render :json => {:success => "false", :message => "Something wrong, #{msg.join("\n")}"}
#    end
#
#  end
#
#end
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#class WebServicesController < ApplicationController
#
#  skip_before_filter :authenticate_user!
#  before_filter :check_session_create, :except => [:create_an_account,:send_user_information,:search_filtered_celebrities,:search_celebrity_by_name_or_industry,:get_celebrity_profile,:get_all_celebrities,:forgot_password, :add_payment_and_create_job, :user_sign_up, :user_sign_up_facebook, :forgot_password,:test_function,:test_service]
#  skip_before_filter :verify_authenticity_token
#  #require 'json_builder'
#  respond_to :json, :html
#
#  def index
#  end
#
#  #def user_sign_up_facebook
#  #  #localhost:3000/web_services/user_sign_up_facebook?[user][first_name]=first&[user][last_name]=last&[user][email]=asad.rehman@whiterabbit.is&[user][password]=12345678&[user][user_type]=user&[facebook_id]=9876543210
#  #  puts "+++++++++++++++++++facebook_sign_up+++++++++++++++++++"
#  #  puts "000000000000000000000", params.inspect
#  #  begin
#  #    if request.format(request) == '*/*'
#  #      if params[:facebook_id].present?
#  #        @user = User.where(:facebook_id => params[:facebook_id]).first
#  #        if @user.present?
#  #          render :json => {:success => "true", :message => "signed in successfully", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,  :token => @user.session_token }}
#  #          @user.update_attributes(:sign_in_count => @user.sign_in_count + 1, :device_token => params[:user][:device_token])
#  #        else
#  #          random_str = SecureRandom.hex
#  #          @user = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password],:user_type => params[:user][:user_type], :facebook_id => params[:facebook_id], :device_token => params[:user][:device_token], :session_token => random_str)
#  #          if @user.save
#  #            create_customer_on_braintree(@user)
#  #            #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
#  #            #create_customer_to_braintree(@user)
#  #            render :json => {:success => "true", :message => "user has been successfully created", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token }}
#  #            @user.update_attributes(:sign_in_count => @user.sign_in_count + 1)
#  #          else
#  #            render :json => {:success => "false", :message => "cant create user"}
#  #          end
#  #        end
#  #      else
#  #        render :json => {:success => "false", :message => "cant create user facebook id does not exist"}
#  #      end
#  #    end
#  #  rescue Exception => e
#  #    return render :json => {:success => "false", :message => "#{e.message}"}
#  #  end
#  #
#  #end
#
#  def create_an_account
#    #localhost:3000/web_services/create_an_account?[user][first_name]=first&[user][last_name]=last&[user][email]=tahir.khan@whiterabbit.is&[user][password]=12345678&[user][user_type]=user
#    puts "+++++++++++++++++++sign_up+++++++++++++++++++"
#    puts "000000000000000000000", params.inspect
#    params[:email] = "test@gmail.com"
#    params[:password] = "1234567890"
#    begin
#      unless params[:email].blank? || params[:password].blank?
#        @already_user = User.where(:email => params[:email]).first
#        if @already_user.blank?
#          random_str = SecureRandom.hex
#          @user = User.new(:email => params[:email], :password => params[:password],:user_type => "user", :device_token => "321321321321321", :session_token => random_str)
#          if @user.save
#            create_customer_on_braintree(@user)
#            render :json => {:success => "true", :message => "user has been successfully created", :user => {:user_id => @user.id, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token}}
#          else
#            render :json => {:success => "false", :message => "cant create user"}
#          end
#        else
#          render :json => {:success => "false", :message => "email already exists"}
#        end
#      else
#        render :json => {:success => "false", :message => "both email and password are required to sign up"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#
#  def user_sign_up(email, password,device_token)
#    #localhost:3000/web_services/user_sign_up?[user][first_name]=first&[user][last_name]=last&[user][email]=tahir.khan@whiterabbit.is&[user][password]=12345678&[user][user_type]=user
#    puts "+++++++++++++++++++sign_up+++++++++++++++++++"
#    puts "000000000000000000000", params.inspect
#    random_str = SecureRandom.hex
#    @user = User.new(:email => email, :password => password,:user_type => "user", :device_token => device_token, :session_token => random_str)
#    #if
#    #@user.save
#    #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
#    #create_customer_to_braintree(@user)
#    #render :json => {:success => "true", :message => "user has been successfully created", :user => {:id => @user.id,:first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token}}
#    #return true
#    #else
#    #  return render :json => {:success => "false", :message => "cant create user"}
#    #end
#
#  end
#
#  def update_password
#
#    puts "_________________________update_password_________________________"
#    puts "000000000000000000000", params.inspect
#    begin
#      if @user.valid_password?(params[:user][:current_password])
#        @user.update_attributes(:password => params[:user][:new_password])
#        render :json => {:success => "true", :message => "Matched, password changed successfully"}
#      else
#        render :json => {:success => "false", :message => "your password does not match varification"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def forgot_password
#    @user = User.find(4)
#    puts "_________________________forgot_password_________________________"
#    puts "000000000000000000000", params.inspect
#    #params[:email] = "tahir.khan@whiterabbit.is"
#    begin
#      #@user = User.where(:email => params[:user][:email]).first
#      puts "------------@user.inspect-----------------", @user.inspect
#      unless @user.blank?
#        @user = User.send_reset_password_instructions(@user)
#        render :json => {:success => "true", :message => "email successfully send"}
#      else
#        render :json => {:success => "false", :message => "User is not registered with this email,Invalid Email"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#
#  def get_all_celebrities
#    begin
#      @celebrity_users = User.all_non_deleted_celebrities#.all.where(:user_type => "celebrity")
#      celebrity_array = []
#      @celebrity_users.each do |user|
#        celebrity_array << {:id => user.id,:first_name => user.first_name, :last_name => user.last_name, :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "" }
#      end
#                                                         #@sub_categories = Category.where(:parent_id => nil)
#      unless celebrity_array.blank?
#        render :json => {:success => "true", :celebrity_array => celebrity_array}
#      else
#        render :json => {:success => "false", :message => "No record found, Celebrities does not exists"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#  def get_celebrity_profile
#    begin
#      #params[:user_id] = "3"
#      @celebrity_user = User.find_celeb(params[:user_id])
#      unless @celebrity_user.blank?
#        render :json => {:success => "true", :message => "successfully get celebrity",:id => @celebrity_user.id,:first_name => @celebrity_user.first_name, :last_name => @celebrity_user.last_name, :about_me => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.about_me : "", :description => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.description : "", :default_rate => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.default_rate : "",:url => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.avatar.url : "" }
#      else
#        render :json => {:success => "false", :message => "No record found, Celebrities does not exists"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def search_celebrity_by_name_or_industry
#    begin
#      #params[:search_name] = "cele"
#      all_celebrities = []
#      if params[:search_name].present?
#        @celebrity_users = User.search_celeb_by_name_or_industry(params[:search_name]) #.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
#        unless @celebrity_users.blank?
#          @celebrity_users.each do |user|
#            all_celebrities << {:id => user.id,:first_name => user.first_name, :last_name => user.last_name, :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : ""}
#          end
#          return render :json => {:success => "true", :all_celebrities => all_celebrities}
#        else
#          return render :json => {:success => "false", :message => "No Record Found!...", :all_celebrities => all_celebrities}
#        end
#      else
#        return render :json => {:success => "false", :message => "Missings Params,search params does not exist"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#  def search_filtered_celebrities
#    begin
#      #params[:price] = "200"
#      all_celebrities = []
#      if params[:price].present?
#        @celebrity_users = User.all_non_deleted_celebrities#.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
#        unless @celebrity_users.blank?
#          @celebrity_users.each do |user|
#            if (user.celebrity.default_rate == params[:price].to_f)
#              all_celebrities << {:id => user.id,:first_name => user.first_name, :last_name => user.last_name, :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : ""}
#            end
#          end
#          return render :json => {:success => "true", :all_celebrities => all_celebrities}
#        else
#          return render :json => {:success => "false", :message => "No Record Found!...", :all_celebrities => all_celebrities}
#        end
#      else
#        return render :json => {:success => "false", :message => "Missings Params,search params does not exist"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#  def add_payment_and_create_job
#    begin
#      params[:email] = "tahir.khan@whiterabbit.is"
#      params[:password] = "1234567890"
#      params[:device_token] = "321321321321321321"
#      params[:cvv] = "123"
#      params[:credit_card_number] = "4111111111111111"
#      params[:expiration_date] = "05/2020"
#      params[:cardholder_name] = "tahir khan lodhi"
#      params[:message_for] = "adeel ahmed"
#      params[:pronounce_like] = "Pronounced like--> ad-eel ah-med"
#      params[:event_type_id] = 1
#      params[:message_details] = "hi adeel happy birthday buddy ,Good..."
#      params[:celebrity_id] = 5
#      params[:is_gift] = 1
#      if (params[:email].present? && params[:password].present? && params[:device_token].present? && params[:cvv].present? && params[:credit_card_number].present? && params[:expiration_date].present? && params[:cardholder_name].present?)
#        unless params[:email].blank? || params[:password].blank?
#          @already_user = User.where(:email => params[:email]).first
#          if @already_user.blank?
#            #user_sign_up(params[:email], params[:password], params[:device_token])
#            random_str = SecureRandom.hex
#            @user = User.new(:email => params[:email], :password => params[:password],:user_type => "user", :device_token => params[:device_token], :session_token => random_str)
#            if @user.save
#              @user_job = Job.new(:message_for => params[:message_for], :pronounce_like => params[:pronounce_like],:is_gift => params[:is_gift], :event_type_id => params[:event_type_id],:message_details => params[:message_details],:deadline => params[:deadline],:status => "pending", :celebrity_id=> params[:celebrity_id],:user_id => @user.id, :customer_job_id => Time.now)
#              @user_job.save
#              create_customer_on_braintree(@user)
#              add_credit_card_payment_method(params[:cvv], params[:credit_card_number], params[:expiration_date], params[:cardholder_name],@user,@user_job)
#
#            else
#              return render :json => {:success => "false", :message => "cant create user"}
#            end
#            #render :json => {:success => "true", :errors => "job successfully created"}
#          else
#            return render :json => {:success => "false", :message => "email already exists"}
#          end
#        else
#          return render :json => {:success => "false", :message => "both email and password are required to sign up"}
#        end
#      else
#        params[:user_id] = 7
#        if params[:user_id].present?
#          @user = User.find(params[:user_id])
#          customer = Braintree::Customer.find(@user.customer_id)
#          if (customer.credit_cards.present? && customer.credit_cards.first.token.present?)
#            result = Braintree::CreditCard.update(
#                customer.credit_cards.first.token,
#                :number => params[:credit_card_number],
#                :expiration_date => params[:expiration_date],
#                :cvv => params[:cvv],
#                :cardholder_name => params[:cardholder_name],
#            )
#            #return render :json => {:success => "true", :message => "Card Updated Successfully",:result => {:card_token => result.credit_card.token,:card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name,:type => result.credit_card.card_type,:expiration_month => result.credit_card.expiration_month,:expiration_year => result.credit_card.expiration_year}}
#            if result.success?
#              @user_job = Job.new(:message_for => params[:message_for], :pronounce_like => params[:pronounce_like],:is_gift => params[:is_gift], :event_type_id => params[:event_type_id],:message_details => params[:message_details],:deadline => params[:deadline],:status => "pending", :celebrity_id=> params[:celebrity_id],:user_id => @user.id, :customer_job_id => Time.now)
#              @user_job.save
#              puts "_________________________result.success?_________________________", result.inspect
#              braintree_information = BraintreeInfo.find_by_payment_method_token(customer.credit_cards.first.token)
#              braintree_information.update_attributes(:user_id => @user.id, :customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
#              create_transaction(@user,@user_job)
#              #render :json => {:success => "true", :message => "Your Credit Card Has Been Successfully Updated", :result => {:card_token => result.credit_card.token, :card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name, :type => result.credit_card.card_type, :expiration_month => result.credit_card.expiration_month, :expiration_year => result.credit_card.expiration_year}}
#            else
#              render :json => {:success => "false", :message => result.message} #errors.each{|a|a.message}
#            end
#          end
#        else
#          render :json => {:success => "false", :message => "Missing Params"} #errors.each{|a|a.message}
#        end
#      end
#        #render :json => {:success => "true", :errors => "job successfully created", :user_job => @user_job}
#        #else
#        #render :json => {:success => "true", :errors => "Error, Some thing missing in create job"}
#        #end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def add_credit_card_payment_method(cvv,credit_card_number,expiration_date,cardholder_name,user,job)
#    puts "_________________________add_credit_card_payment_method_________________________"
#    #begin
#    #params[:cvv] = 123
#    #params[:credit_card_number] = "4005519200000004"
#    #params[:expiration_date] = "05/2020"
#    #params[:cardholder_name] = "tahir khan"
#    #4005519200000004
#    #4009348888881881
#    #4012000033330026
#    #4012000077777777
#    #4012888888881881
#    #4217651111111119
#    #4500600000000061
#    result = Braintree::CreditCard.create(
#        :customer_id => user.customer_id,
#        :cvv => cvv,
#        :number => credit_card_number,
#        :expiration_date => expiration_date,
#        :cardholder_name => cardholder_name,
#        :options => {
#            :verify_card => true,
#            :fail_on_duplicate_payment_method => true,
#            :make_default => true
#        }
#    )
#    if result.success?
#      puts "_________________________result.success?_________________________", result.inspect
#      @braintree_info = BraintreeInfo.create(:user_id => @user.id,:customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
#      create_transaction(@user,job)
#      #render :json => {:success => "true", :message => "Your Credit Card Has Been Successfully Added", :result => {:card_token => result.credit_card.token, :card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name, :type => result.credit_card.card_type, :expiration_month => result.credit_card.expiration_month, :expiration_year => result.credit_card.expiration_year}}
#    else
#      #@user = User.find(:email => user.email).first
#      result1 = Braintree::Customer.delete(@user.customer_id)
#      if result1.success?
#        puts "customer successfully deleted"
#      else
#        raise "this should never happen"
#      end
#      if @user.destroy
#        @user.jobs.last.destroy
#      end
#      render :json => {:success => "false", :message => result.message} #errors.each{|a|a.message}
#    end
#    #rescue Exception => e
#    #  return render :json => {:success => "false", :message => "#{e.message}"}
#    #end
#  end
#
#  def fetch_customer_payment_methods
#    puts "_________________________fetch_customer_payment_methods_________________________"
#    puts "000000000000000000000", params.inspect
#    begin
#      if @user.customer_id.present?
#        customer = Braintree::Customer.find(@user.customer_id)
#        puts "111111111111111111111111111111111111", customer.inspect
#        cards_array = []
#        puts "222222222222222222222222222222222222", customer.credit_cards.inspect
#        customer.credit_cards.each do |a|
#          cards_array << {:card_token => a.token, :card_number => a.masked_number, :name => a.cardholder_name, :type => a.card_type, :expiration_month => a.expiration_month, :expiration_year => a.expiration_year}
#        end
#        if customer.present?
#          if customer.credit_cards.present?
#            render :json => {:success => "true", :message => "Your  Customer Has Been Successfully Fetched", :customer => cards_array}
#          else
#            render :json => {:success => "false", :message => "This customer does not have saved payment methods."}
#          end
#        else
#          render :json => {:success => "false", :message => "No Record Found On Braintree"}
#        end
#      else
#        render :json => {:success => "false", :message => "Braintree customer does not exists"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def update_credit_card_payment_method()
#    puts "_________________________update_credit_card_payment_method_________________________"
#    puts "000000000000000000000", params.inspect
#    #params[:card_token] = "6frcxg"
#    begin
#      params[:cvv] = 123
#      params[:credit_card_number] = "4009348888881881"
#      params[:expiration_date] = "05/2020"
#      params[:cardholder_name] = "tahir khan lodhi"
#      params[:card_token] = "k8t6hg"
#      if params[:card_token].present?
#        result = Braintree::CreditCard.update(
#            params[:card_token],
#            :number => params[:credit_card_number],
#            :expiration_date => params[:expiration_date],
#            :cvv => params[:cvv],
#            :cardholder_name => params[:cardholder_name],
#        )
#        #return render :json => {:success => "true", :message => "Card Updated Successfully",:result => {:card_token => result.credit_card.token,:card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name,:type => result.credit_card.card_type,:expiration_month => result.credit_card.expiration_month,:expiration_year => result.credit_card.expiration_year}}
#        if result.success?
#          puts "_________________________result.success?_________________________", result.inspect
#          braintree_information = BraintreeInfo.find_by_payment_method_token(params[:card_token])
#          braintree_information.update_attributes(:user_id => @user.id, :customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
#          render :json => {:success => "true", :message => "Your Credit Card Has Been Successfully Updated", :result => {:card_token => result.credit_card.token, :card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name, :type => result.credit_card.card_type, :expiration_month => result.credit_card.expiration_month, :expiration_year => result.credit_card.expiration_year}}
#        else
#          render :json => {:success => "false", :message => result.message} #errors.each{|a|a.message}
#        end
#      else
#        return render :json => {:success => result.to_s, :message => "Credit Card Token Not Present"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def send_user_information
#    params[:user_id] = "7"
#    @user = User.find(params[:user_id])
#    begin
#      if @user.customer_id.present?
#        customer = Braintree::Customer.find(@user.customer_id)
#        puts "111111111111111111111111111111111111", customer.inspect
#        cards_array = []
#        puts "222222222222222222222222222222222222", customer.credit_cards.inspect
#        customer.credit_cards.each do |a|
#          cards_array << {:c => a.inspect}#:card_token => a.token, :card_number => a.masked_number, :name => a.cardholder_name, :type => a.card_type, :expiration_month => a.expiration_month, :expiration_year => a.expiration_year, :cvv => a.cvv}
#        end
#        if customer.present?
#          if customer.credit_cards.present?
#            render :json => {:success => "true", :message => "Your  Customer Has Been Successfully Fetched", :email => @user.email,:customer => cards_array}
#          else
#            render :json => {:success => "false", :message => "This customer does not have saved payment methods."}
#          end
#        else
#          render :json => {:success => "false", :message => "No Record Found On Braintree"}
#        end
#      else
#        render :json => {:success => "false", :message => "Braintree customer does not exists"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#  def check_session_create
#    params[:token] = "9a0ca3b42e0f7e1fdf198802299e75b8" if Rails.env == "development"
#    puts "_________________________check_session_create_________________________"
#    if params[:token].present?
#      @user = User.find_by_session_token(params[:token])
#      if @user.present?
#        puts "********user exists**********"
#        return true
#      else
#        puts "*********user does not exist************"
#        render :json => {:success => "false", :errors => " authentication failed.."}
#      end
#    else
#      puts "***********params token not present*************"
#      render :json => {:success => "false", :errors => " authentication failed.."}
#    end
#  end
#
#  def create_customer_on_braintree(user)
#    result = Braintree::Customer.create(
#        :first_name => user.first_name.present? ? user.first_name : "",
#        :last_name => user.last_name.present? ? user.last_name : "",
#        :email => user.email
#    )
#    puts "----------Brain tree result----------",result.inspect
#    if result.success?
#      user.update_attributes(:customer_id => result.customer.id)
#    else
#      puts "---------brain tree ustomer create error-----------", result.errors
#    end
#  end
#
#  def test_service
#    @user = User.find(14)
#    jobs = @user.jobs.last.destroy
#    return render :json => {:success => "true", :message => "Successfully", :user => @user, :jobs => jobs}
#  end
#
#
#  def create_transaction(user,job)
#    result = Braintree::Transaction.sale(
#        :customer_id => user.customer_id,
#        #:service_fee_amount => ApplicationHelper::CELEBVIDY_FEE,
#        #:merchant_account_id => merchant.merchant_id,
#        :amount => "100.0",
#        :payment_method_token => user.braintree_infos.first.payment_method_token,
#        :options => {
#            :submit_for_settlement => true
#        }
#    )
#    if result.success?
#      #<Braintree::SuccessfulResult transaction:#<Braintree::Transaction id: "84q6n8",
#      # type: "sale",
#      # amount: "20.0",
#      # status: "submitted_for_settlement",
#      # created_at: 2015-02-03 14:01:35 UTC,
#      # credit_card_details: #<token: "hdn3j2",
#      # bin: "401288",
#      # last_4: "1881",
#      # card_type: "Visa",
#      # expiration_date: "05/2020",
#      # cardholder_name: "tahirkhanlodhi",
#      # customer_location: "US",
#      # prepaid: "No",
#      # healthcare: "Unknown",
#      # durbin_regulated: "Unknown",
#      # debit: "Unknown",
#      # commercial: "Unknown",
#      # payroll: "Unknown",
#      # country_of_issuance: "USA",
#      # issuing_bank: "Unknown">,
#      # customer_details: #<id: "81174133",
#      # first_name: "khan",
#      # last_name: "khan",
#      # email: "khan@yahoo.com",
#      # company: nil,
#      # website: nil,
#      # phone: "+923317612147",
#      # fax: nil>,
#      # subscription_details: #<Braintree::Transaction::SubscriptionDetails:0x007f2758b8e0d0 @billing_period_end_date=nil, @billing_period_start_date=nil>, updated_at: 2015-02-03 14:01:36 UTC>>
#      puts "yahuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu", result.inspect
#      @history = TransactionHistory.create(:transaction_id => result.transaction.id, :transaction_type => result.transaction.type, :status => result.transaction.status, :transaction_amount => '100', :merchant_id => "", :customer_id => @user.customer_id, :user_id => @user.id, :job_id => job.id)
#      render :json => {:success => "true",:message => "transaction successfull", :result => result.inspect}#, :result => result, :message => "You have purchased '#{pro.title.present? ? pro.title.to_s : ""}' from #{pro.user.present? ? pro.user.name : ""} for $ #{pro.price.present? ? pro.price.to_f : ""}"}
#    else
#      return render :json => {:success => "false", :message => "transaction not Successful",:result => result.inspect}
#    end
#  end
#
#
#
#  def test_function
#    begin
#      @user = User.find(3)
#      #create_customer_to_braintree(@user)
#      create_merchant_to_braintree("1123581321", "071101307")
#
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#
#  def aadd_credit_card_payment_method
#    begin
#      #4005519200000004
#      #4009348888881881
#      #4012000033330026
#      #4012000077777777
#      #4012888888881881
#      #4217651111111119
#      #4500600000000061
#      #params[:credit_card_number] = "4005519200000004"
#      #params[:cardholder_name] = "tahirkhanlodhi"
#      #params[:expiration_date] = "05/2020"
#      result = Braintree::CreditCard.create(
#          :customer_id => '51440284',
#          :cvv => '123',
#          :number => '4500600000000061',
#          :expiration_date => '05/2025',
#          :cardholder_name => 'test',
#          :options => {
#              :verify_card => true,
#              :fail_on_duplicate_payment_method => true,
#              :make_default => true
#          }
#      )
#      if result.success?
#        puts "_________________________result.success?_________________________", result.inspect
#        render :json => {:success => "true", :message => "Your Credit Card Has Been Successfully Added", :result => {:card_token => result.credit_card.token, :card_number => result.credit_card.masked_number, :name => result.credit_card.cardholder_name, :type => result.credit_card.card_type, :expiration_month => result.credit_card.expiration_month, :expiration_year => result.credit_card.expiration_year}}
#      else
#        render :json => {:success => "false", :message => result.message} #errors.each{|a|a.message}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#  end
#
#
#
#
#
#
#
#
#
#
#
#  #_______________________________________________________________________________________________________
#  #-------------------------------------------------------------------------------------------------------
#  #______________________________WEB SERVICES FOR CELEBRITIES_____________________________________________
#  #-------------------------------------------------------------------------------------------------------
#  #_______________________________________________________________________________________________________
#  def celebrity_sign_up_facebook
#    #localhost:3000/web_services/user_sign_up_facebook?[user][first_name]=first&[user][last_name]=last&[user][email]=asad.rehman@whiterabbit.is&[user][password]=12345678&[user][user_type]=celebrity&[facebook_id]=9876543210
#    puts "+++++++++++++++++++facebook_sign_up+++++++++++++++++++"
#    puts "000000000000000000000", params.inspect
#    begin
#      if request.format(request) == '*/*'
#        if params[:facebook_id].present?
#          @user = User.where(:facebook_id => params[:facebook_id]).first
#          if @user.present?
#            render :json => {:success => "true", :message => "signed in successfully", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,  :token => @user.session_token }}
#            @user.update_attributes(:sign_in_count => @user.sign_in_count + 1, :device_token => params[:user][:device_token])
#          else
#            random_str = SecureRandom.hex
#            @user = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password],:user_type => params[:user][:user_type], :facebook_id => params[:facebook_id], :device_token => params[:user][:device_token], :session_token => random_str)
#            if @user.save
#              create_merchant_to_braintree("1123581321", "071101307")
#              #create_customer_on_braintree(@user)
#              #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
#              #create_customer_to_braintree(@user)
#              render :json => {:success => "true", :message => "celebrity has been successfully created", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token }}
#              @user.update_attributes(:sign_in_count => @user.sign_in_count + 1)
#            else
#              render :json => {:success => "false", :message => "cant create celebrity"}
#            end
#          end
#        else
#          render :json => {:success => "false", :message => "celebrity create user facebook id does not exist"}
#        end
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#
#  def celebrity_sign_up
#    #localhost:3000/web_services/user_sign_up?[user][first_name]=first&[user][last_name]=last&[user][email]=tahir.khan@whiterabbit.is&[user][password]=12345678&[user][user_type]=celebrity
#    puts "+++++++++++++++++++sign_up+++++++++++++++++++"
#    puts "000000000000000000000", params.inspect
#    begin
#      unless params[:user][:email].blank? || params[:user][:password].blank?
#        @already_user = User.where(:email => params[:user][:email]).first
#        if @already_user.blank?
#          random_str = SecureRandom.hex
#          @user = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password],:user_type => params[:user][:user_type], :device_token => params[:user][:device_token], :session_token => random_str)
#          if @user.save
#            create_merchant_to_braintree("1123581321", "071101307")
#            #create_customer_on_braintree(@user)
#            #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
#            #create_customer_to_braintree(@user)
#            render :json => {:success => "true", :message => "celebrity has been successfully created", :user => {:id => @user.id,:first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token}}
#          else
#            render :json => {:success => "false", :message => "cant create celebrity"}
#          end
#        else
#          render :json => {:success => "false", :message => "email already exists"}
#        end
#      else
#        render :json => {:success => "false", :message => "both email and password are required to sign up"}
#      end
#    rescue Exception => e
#      return render :json => {:success => "false", :message => "#{e.message}"}
#    end
#
#  end
#
#  def create_merchant_to_braintree(acc_num, rou_num)
#    puts "_________________________create_merchant_to_braintree(acc_num, rou_num,bank_name)---------------------"
#    puts "000000000000000000000", params.inspect
#    @result = Braintree::MerchantAccount.create(
#        :individual => {
#            :first_name => "Jane",
#            :last_name => "Doe",
#            :email => "celeb1@gmail.com",
#            :phone => "5553334444",
#            :date_of_birth => "2000-01-01",
#            #:ssn => "456-45-4567",
#            :address => {
#                :street_address => "111 Main St",
#                :locality => "chicago",
#                :region => "IL",
#                :postal_code => "60622"
#            }
#        },
#        :funding => {
#            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
#            :email => 'celeb1@gmail.com',
#            :mobile_phone => "5553334444",
#            :account_number => acc_num,
#            :routing_number => rou_num
#        },
#        :tos_accepted => true,
#        :master_merchant_account_id => "ycdtqqj2qjby6wgt"
#    )
#    if @result.success?
#      puts "------------add success @result", @result.inspect
#      puts "------------add success @result merchant_account.id", @result.merchant_account.id
#      render :json => {:success => "true", :message => @result.inspect }
#      #@user.merchant_id = @result.merchant_account.id
#      #if @user.update_attribute(:merchant_id, @result.merchant_account.id)
#      #  render :json => {:success => "true", :message => "Braintree account successfully created"}
#      #else
#      #  render :json => {:success => "false", :message => "User not Updated, merchant id not added"}
#      #end
#    else
#      msg ||= []
#      @result.errors.each { |error| msg << error.message }
#      render :json => {:success => "false", :message => "Something wrong, #{msg.join("\n")}"}
#    end
#
#  end
#
#
#  def create_merchant_on_braintree(acc_num, rou_num)
#    puts "_________________________create_merchant_to_braintree(acc_num, rou_num,bank_name)---------------------"
#    puts "000000000000000000000", params.inspect
#    @result = Braintree::MerchantAccount.create(
#        :individual => {
#            :first_name => @user.name,
#            :last_name => @user.name,
#            :email => @user.email,
#            :phone => @user.profile.phone_number,
#            :date_of_birth => "2000-01-01",
#            #:ssn => "456-45-4567",
#            :address => {
#                :street_address => @user.street_address,
#                :locality => @user.city,
#                :region => @user.state,
#                :postal_code => @user.zip_code
#            }
#        },
#        :funding => {
#            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
#            :email => @user.email,
#            :mobile_phone => @user.profile.phone_number,
#            :account_number => acc_num,
#            :routing_number => rou_num
#        },
#        :tos_accepted => true,
#        :master_merchant_account_id => "7yfqk2bwhgzspd35"
#    )
#    if @result.success?
#      puts "------------add success @result", @result.inspect
#      puts "------------add success @result merchant_account.id", @result.merchant_account.id
#      #@user.merchant_id = @result.merchant_account.id
#      if @user.update_attribute(:merchant_id, @result.merchant_account.id)
#        render :json => {:success => "true", :message => "Braintree account successfully created"}
#      else
#        render :json => {:success => "false", :message => "User not Updated, merchant id not added"}
#      end
#    else
#      msg ||= []
#      @result.errors.each { |error| msg << error.message }
#      render :json => {:success => "false", :message => "Something wrong, #{msg.join("\n")}"}
#    end
#
#  end
#
#end
