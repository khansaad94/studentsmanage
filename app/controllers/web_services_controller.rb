class WebServicesController < ApplicationController

  include Devise
  include ActionView::Helpers::NumberHelper
  require "open-uri"
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  before_filter :check_session_create, :except => [:test_url, :testtt,:testabc,:update_password,:check_device_code,:submit_agent_code,:check_twitter_celebrity, :test_service,:celebrity_sign_up,:push_testing,:push_testinga,:push_testingb,:push_testingc, :get_all_event_types, :get_all_industries, :create_transactions, :create_an_account, :search_filtered_celebrities, :search_celebrity_by_name_or_industry, :get_celebrity_profile, :get_all_celebrities, :forgot_password, :add_payment_and_create_job, :forgot_password]
  skip_before_filter :verify_authenticity_token
  #require 'json_builder'
  respond_to :json, :html

  def index
    # p "sdsdfdsf", Devise.token_generator.digest(self, :reset_password_token, 'MbaVaQKAi7E9YSEsg92k')
  end

 #def submit_agent_code
 #
 #  aaaaaaaaaaaaaaaaaaaaaaaa
 #end
  #def user_sign_up_facebook
  #  #localhost:3000/web_services/user_sign_up_facebook?[user][first_name]=first&[user][last_name]=last&[user][email]=asad.rehman@whiterabbit.is&[user][password]=12345678&[user][user_type]=user&[facebook_id]=9876543210
  #  puts "+++++++++++++++++++facebook_sign_up+++++++++++++++++++"
  #  puts "000000000000000000000", params.inspect
  #  begin
  #    if request.format(request) == '*/*'
  #      if params[:facebook_id].present?
  #        @user = User.where(:facebook_id => params[:facebook_id]).first
  #        if @user.present?
  #          render :json => {:success => "true", :message => "signed in successfully", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,  :token => @user.session_token }}
  #          @user.update_attributes(:sign_in_count => @user.sign_in_count + 1, :device_token => params[:user][:device_token])
  #        else
  #          random_str = SecureRandom.hex
  #          @user = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password],:user_type => params[:user][:user_type], :facebook_id => params[:facebook_id], :device_token => params[:user][:device_token], :session_token => random_str)
  #          if @user.save
  #            create_customer_on_braintree(@user)
  #            #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
  #            #create_customer_to_braintree(@user)
  #            render :json => {:success => "true", :message => "user has been successfully created", :user => {:id => @user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token }}
  #            @user.update_attributes(:sign_in_count => @user.sign_in_count + 1)
  #          else
  #            render :json => {:success => "false", :message => "cant create user"}
  #          end
  #        end
  #      else
  #        render :json => {:success => "false", :message => "cant create user facebook id does not exist"}
  #      end
  #    end
  #  rescue Exception => e
  #    return render :json => {:success => "false", :message => "#{e.message}"}
  #  end
  #
  #end

  def create_an_account
    begin
      if params[:user_type] == "celebrity" && params[:user][:twitter_id].present?
        @already_user = User.where(:twitter_id => params[:user][:twitter_id]).first if params[:user][:twitter_id].present?
        if @already_user.blank?
        random_str = SecureRandom.hex
        @user = User.new(:first_name => params[:user][:full_name].split(" ")[0],:last_name => params[:user][:full_name].split(" ")[1], :full_name => params[:user][:full_name],:twitter_id => params[:user][:twitter_id], :user_type => "celebrity", :device_token => params[:device_token], :session_token => random_str, :is_active => false)
        if @user.save
          @user.update_attributes(:agent_code => "CELEB" + rand(12345).to_s + @user.id.to_s)
          @celebrity = Celebrity.create(:user_id => @user.id, :about_me => "", :description => "", :default_rate => "20", :per_alphabet_rate => "0", :industry_id => "1")
          avatar = URI.parse(params[:user][:profile_url].split("_normal")[0] + "." +  params[:user][:profile_url].split("_normal")[1].split(".")[1]) if params[:user][:profile_url].present?
          @celebrity.update_attributes(:avatar => avatar) if avatar.present?
          #@celebrity.avatar = URI.parse(params[:user][:profile_url]) if params[:user][:profile_url].present?
          #@celebrity = Celebrity.create(:user_id => @user.id) if @user.celebrity.blank?
          if (@user.celebrity.present? && @user.celebrity.industry_id.present?)
          industry = Industry.find(@user.celebrity.industry_id)
          end
          monthly = @user.celebrity.monthly_videos.present? ? @user.celebrity.monthly_videos : 0
          additional = @user.celebrity.additional_monthly_videos.present? ? @user.celebrity.additional_monthly_videos : 0
          total = monthly + additional
          remaining = get_remaining_videos(@user.id)
          # //////////////////////////////////////////////////////
          # /celebrity-upsert?celebrity_id=<king tide db id>&agent_code=&bio=bla+bla&inventory=100&full_name=&twitter=&industry=&start_date=&email=&paybycheck=&vendor_type=<individual|company>&tin=&price=$100&address=&city=&state=&zip=&charity=&charity_percent=&away=&profile_pic_url=&etc=<just document anything else u give me here>
          #///////////////////////////////////////////////////////
          return render :json => {:success => "true",:view => "profile", :message => "Celebrity Signed in Successfully..", :user => {:id => @user.id, :twitter_user => @user.twitter_id.present? ? true : false, :payment_flag => @user.payment_by_check,:first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :email => @user.email.present? ? @user.email : "", :user_type => @user.user_type, :url => @user.celebrity.present? ? @user.celebrity.avatar.url : "", :token => @user.session_token, :verified_account => @user.celebrity.present? ? @user.celebrity.verified_account : false, :code_verify => @user.code_verify,:is_braintree_configured => (@user.merchant_id.present? || (@user.celebrity.present? && @user.celebrity.payment_address.present?)) ? true : false}, :celebrity => {:id => @user.id, :first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :email => @user.email.present? ? @user.email : "", :user_type => @user.user_type, :url => (@user.celebrity.present? && @user.celebrity.avatar.present?) ? @user.celebrity.avatar.url : "", :monthly_videos => total.present? ? total : 0,:default_monthly_inventory => "100", :push_notification => @user.push_notification.present? ? @user.push_notification : false, :away_mode => @user.away_mode.present? ? @user.away_mode : false, :charity_rate => @user.celebrity.charity_rate.present? ? @user.celebrity.charity_rate : 0,:remaining_videos => remaining.present? ? remaining : 0,:default_rate => @user.celebrity.default_rate.present? ? @user.celebrity.default_rate : 0 }, :industry => industry.present? ? industry.title : ""}
        else
          return render :json => {:success => "false",  :message => "Celebrity Signed up Error!, #{@user.errors.inspect}"}
        end
        else
          if @already_user.celebrity.present? && @already_user.celebrity.verified_account == true
            if params[:user_type] == "celebrity"
              avatar = URI.parse(params[:user][:profile_url].split("_normal")[0] + "." + params[:user][:profile_url].split("_normal")[1].split(".")[1]) if params[:user][:profile_url].present?
              @already_user.celebrity.update_attributes(:avatar => avatar) if avatar.present?
              @pending_jobs = Job.all.where(:status => "admin_approved_job", :celebrity_id => @already_user.id).order("updated_at DESC")
              jobs = []
              @pending_jobs.each do |a|
                event = EventType.find(a.event_type_id)
                jobs << {:job_id => a.id, :job_type => event.name,:job_message_for => a.message_for,:pronounce_like => a.pronounce_like, :is_gift => a.is_gift,:message_details => a.message_details, :job_status => a.status, :job_message_for => a.message_for, :job_date => a.created_at.present? ? a.created_at.strftime("%-m/%-d/%Y") : "", :url => a.status == "completed" ? a.video_url : "",:deadline => a.deadline.present? ? a.deadline.strftime("%-m/%-d/%Y") : ""}
              end
              if @already_user.celebrity.video_url.blank?
                jobs << {:job_id => 000, :job_message_for => "Introduce Yourself", :job_date => "Record a brief Video", :job_type => "", :job_status => "", :pronounce_like => "", :is_gift => true, :message_details => "", :url => "",:deadline => ""}
              end
              #//////////////////////////////////////////////////////
              # /celebrity-upsert?celebrity_id=<king tide db id>&agent_code=&bio=bla+bla&inventory=100&full_name=&twitter=&industry=&start_date=&email=&paybycheck=&vendor_type=<individual|company>&tin=&price=$100&address=&city=&state=&zip=&charity=&charity_percent=&away=&profile_pic_url=&etc=<just document anything else u give me here>
              #//////////////////////////////////////////////////////
              return render :json => {:success => "true",:view => "", :jobs => jobs , :user => {:id => @already_user.id, :twitter_user => @already_user.twitter_id.present? ? true : false,:payment_flag => @already_user.payment_by_check, :first_name => @already_user.first_name.present? ? @already_user.first_name : "", :last_name => @already_user.last_name.present? ? @already_user.last_name : "", :email => @already_user.email.present? ? @already_user.email : "", :user_type => @already_user.user_type, :url => @already_user.celebrity.present? ? @already_user.celebrity.avatar.url : "", :token => @already_user.session_token,:verified_account => @already_user.celebrity.present? ? @already_user.celebrity.verified_account : false, :code_verify => @already_user.code_verify,:is_braintree_configured => (@already_user.merchant_id.present? || (@already_user.celebrity.present? && @already_user.celebrity.payment_address.present?)) ? true : false}, :message => "Celebrity Signed in Successfully!"}
            else
              return render :json => {:success => "false", :message => "You Are Not Authorized To Sign In..."}
            end
          else
            unless @already_user.celebrity.present?
              @already_user.celebrity.create(:about_me => "", :description => "", :default_rate => "20", :per_alphabet_rate => "0",:industry_id => "1")
              avatar = URI.parse(params[:user][:profile_url].split("_normal")[0] + "." +  params[:user][:profile_url].split("_normal")[1].split(".")[1]) if params[:user][:profile_url].present?
              @celebrity.update_attributes(:avatar => avatar) if avatar.present?
            end
            if (@already_user.celebrity.present? && @already_user.celebrity.industry_id.present?)
              industry = Industry.find(@already_user.celebrity.industry_id)
            end
            monthly = @already_user.celebrity.monthly_videos.present? ? @already_user.celebrity.monthly_videos : 0
            additional = @already_user.celebrity.additional_monthly_videos.present? ? @already_user.celebrity.additional_monthly_videos : 0
            total = monthly + additional
            remaining = get_remaining_videos(@already_user.id)
            #////////////////////////////////////////////////////
            # /celebrity-upsert?celebrity_id=<king tide db id>&agent_code=&bio=bla+bla&inventory=100&full_name=&twitter=&industry=&start_date=&email=&paybycheck=&vendor_type=<individual|company>&tin=&price=$100&address=&city=&state=&zip=&charity=&charity_percent=&away=&profile_pic_url=&etc=<just document anything else u give me here>
            #////////////////////////////////////////////////////
            return render :json => {:success => "true",:view => "profile", :message => "Celebrity Signed in Successfully..", :user => {:id => @already_user.id, :twitter_user => @already_user.twitter_id.present? ? true : false, :payment_flag => @already_user.payment_by_check,:first_name => @already_user.first_name.present? ? @already_user.first_name : "", :last_name => @already_user.last_name.present? ? @already_user.last_name : "", :email => @already_user.email.present? ? @already_user.email : "", :user_type => @already_user.user_type, :url => @already_user.celebrity.present? ? @already_user.celebrity.avatar.url : "", :token => @already_user.session_token, :verified_account => @already_user.celebrity.present? ? @already_user.celebrity.verified_account : false, :code_verify => @already_user.code_verify,:is_braintree_configured => (@already_user.merchant_id.present? || (@already_user.celebrity.present? && @already_user.celebrity.payment_address.present?)) ? true : false}, :celebrity => {:id => @already_user.id, :first_name => @already_user.first_name.present? ? @already_user.first_name : "", :last_name => @already_user.last_name.present? ? @already_user.last_name : "", :email => @already_user.email.present? ? @already_user.email : "", :user_type => @already_user.user_type, :url => (@already_user.celebrity.present? && @already_user.celebrity.avatar.present?) ? @already_user.celebrity.avatar.url : "", :monthly_videos => total.present? ? total : 0,:default_monthly_inventory => "100",:push_notification => @already_user.push_notification.present? ? @already_user.push_notification : false, :away_mode => @already_user.away_mode.present? ? @already_user.away_mode : false, :charity_rate => @already_user.celebrity.charity_rate.present? ? @already_user.celebrity.charity_rate : 0,:remaining_videos => remaining.present? ? remaining : 0,:default_rate => @already_user.celebrity.default_rate.present? ? @already_user.celebrity.default_rate : 0 }, :industry => industry.present? ? industry.title : ""}
          end
        end
      end
      unless params[:user][:email].blank? || params[:user][:password].blank?
        @already_user = User.where(:email => params[:user][:email]).first
        if @already_user.blank?
          random_str = SecureRandom.hex
            if params[:user_type] == "celebrity"
              @user = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password], :user_type => "celebrity", :device_token => params[:device_token], :session_token => random_str, :is_active => false)
              if @user.save
                @user.update_attributes(:agent_code => "CELEB" + rand(12345).to_s + @user.id.to_s)
                @celebrity = Celebrity.create(:user_id => @user.id, :about_me => "", :description => "", :default_rate => "20", :per_alphabet_rate => "0",:industry_id => "1")
                if (@user.celebrity.present? && @user.celebrity.industry_id.present?)
                  industry = Industry.find(@user.celebrity.industry_id)
                end
                monthly = @user.celebrity.monthly_videos.present? ? @user.celebrity.monthly_videos : 0
                additional = @user.celebrity.additional_monthly_videos.present? ? @user.celebrity.additional_monthly_videos : 0
                total = monthly + additional
                remaining = get_remaining_videos(@user.id)
                return render :json => {:success => "true",:view => "profile", :message => "Celebrity Signed in Successfully..", :user => {:id => @user.id, :twitter_user => @user.twitter_id.present? ? true : false,:payment_flag => @user.payment_by_check, :first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :email => @user.email.present? ? @user.email : "", :user_type => @user.user_type, :url => @user.celebrity.present? ? @user.celebrity.avatar.url : "", :token => @user.session_token, :verified_account => @user.celebrity.present? ? @user.celebrity.verified_account : false, :code_verify => @user.code_verify,:is_braintree_configured => (@user.merchant_id.present? || (@user.celebrity.present? && @user.celebrity.payment_address.present?)) ? true : false}, :celebrity => {:id => @user.id, :first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :email => @user.email.present? ? @user.email : "", :user_type => @user.user_type, :url => (@user.celebrity.present? && @user.celebrity.avatar.present?) ? @user.celebrity.avatar.url : "", :monthly_videos => total.present? ? total : 0,:default_monthly_inventory => "100",:push_notification => @user.push_notification.present? ? @user.push_notification : false, :away_mode => @user.away_mode.present? ? @user.away_mode : false, :charity_rate => @user.celebrity.charity_rate.present? ? @user.celebrity.charity_rate : 0,:remaining_videos => remaining.present? ? remaining : 0,:default_rate => @user.celebrity.default_rate.present? ? @user.celebrity.default_rate : 0 }, :industry => industry.present? ? industry.title : ""}
              else
                return render :json => {:success => "false",  :message => "Celebrity Signed up Error!, #{@user.errors.inspect}"}
              end

              else
          @user = User.new(:email => params[:user][:email], :password => params[:user][:password], :user_type => "user", :device_token => params[:device_token], :session_token => random_str)
          if @user.save
            create_customer_on_braintree(@user)
            render :json => {:success => "true", :message => "user has been successfully created", :user => {:id => @user.id, :twitter_user => @user.twitter_id.present? ? true : false, :email => @user.email.present? ? @user.email : "", :first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :user_type => @user.user_type, :token => @user.session_token}}
          else
            render :json => {:success => "false", :message => "Oops! Cant create user"}
          end
            end
        else
          render :json => {:success => "false", :message => "Email Already Exists"}
        end
      else
        render :json => {:success => "false", :message => "Both email and password are required to sign up"}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end


  #def user_sign_up(email, password, device_token)
  #  #localhost:3000/web_services/user_sign_up?[user][first_name]=first&[user][last_name]=last&[user][email]=tahir.khan@whiterabbit.is&[user][password]=12345678&[user][user_type]=user
  #  puts "+++++++++++++++++++sign_up+++++++++++++++++++"
  #  puts "000000000000000000000", params.inspect
  #  random_str = SecureRandom.hex
  #  @user = User.new(:email => email, :password => password, :user_type => "user", :device_token => device_token, :session_token => random_str)
  #  #if
  #  #@user.save
  #  #@profile = Profile.create(:about_yourself => params[:user][:profile][:about_yourself], :phone_number => params[:user][:profile][:phone], :distance => params[:user][:profile][:distance], :user_id => @user.id) if @user.present?
  #  #create_customer_to_braintree(@user)
  #  #render :json => {:success => "true", :message => "user has been successfully created", :user => {:id => @user.id,:first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email,:user_type => @user.user_type, :token => @user.session_token}}
  #  #return true
  #  #else
  #  #  return render :json => {:success => "false", :message => "cant create user"}
  #  #end
  #
  #end

  def update_password
    begin
      if params[:token].present?
        @user = User.find_by_session_token(params[:token])
        if @user.present?
          if @user.valid_password?(params[:user][:current_password])
            @user.update_attributes(:password => params[:user][:new_password])
            render :json => {:success => "true", :message => "Matched, password changed successfully"}
          else
            render :json => {:success => "false", :message => "your password does not match varification"}
          end
        else
          render :json => {:success => "false", :errors => " authentication failed.."}
        end
      else
        puts "1111111111111111111111111111111"
     if params[:reset_token].present?
       puts "333333333333333333333333333333333"

       token = Devise.token_generator.digest(self, :reset_password_token, params[:reset_token])
     @user = User.where(:reset_password_token => token).first
       puts "4444444444444444444444444",@user.inspect
       if @user.update_attributes(:password => params[:user][:new_password])
         return render :json => {:success => "true", :message => "Password updated successfully"}
       else
         return render :json => {:success => "false", :message => "Upss! Try Again.."}
       end
       else
         return render :json => {:success => "false", :message => "Password Token Not Present"}
     end

      end

    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  def forgot_password
    puts "ffffffffffffffffffffffffffffffffffffffffffffffffffff"
    begin
      @user = User.where(:email => params[:user][:email]).first
      unless @user.blank?
        puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        @user = User.send_reset_password_instructions(@user)
        render :json => {:success => "true", :message => "email successfully send"}
      else
        render :json => {:success => "false", :message => "User is not registered with this email,Invalid Email"}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end


  def get_all_celebrities
    begin
      @celebrity_users = User.all_non_deleted_celebrities #.all.where(:user_type => "celebrity")
      celebrity_array = []
      @celebrity_users.each do |user|
        industry = Industry.find(user.celebrity.industry_id) if user.celebrity.present?
        celebrity_array << {:id => user.id, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "", :industry => industry.present? ? industry.title : ""}
      end
                                                          #@sub_categories = Category.where(:parent_id => nil)
      unless celebrity_array.blank?
        render :json => {:success => "true", :celebrity_array => celebrity_array}
      else
        render :json => {:success => "false", :message => "No record found, Celebrities does not exists"}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  def get_celebrity_profile
    begin
      if params[:user_id].present?
        @celebrity_user = User.where(:id => params[:user_id], :user_type => 'celebrity', :is_deleted => false, :is_active => true, :away_mode => false).first
        unless @celebrity_user.blank?
          remaining = get_remaining_videos(@celebrity_user.id)
          industry = Industry.find(@celebrity_user.celebrity.industry_id) if @celebrity_user.celebrity.present?
          render :json => {:success => "true", :view => "",:message => "successfully get celebrity..", :id => @celebrity_user.id, :first_name => @celebrity_user.first_name.present? ? @celebrity_user.first_name : "", :last_name => @celebrity_user.last_name.present? ? @celebrity_user.last_name : "",:verified_account => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.verified_account : 0, :about_me => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.about_me : "", :description => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.description : "", :default_rate => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.default_rate : "", :url => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.avatar.url : "", :industry => industry.present? ? industry.title : "",:remaining_videos => remaining.present? ? remaining - 5 : 0}
        else
          render :json => {:success => "false", :message => "No record found, Celebrities does not exists.."}
        end
      else
        render :json => {:success => "false", :message => "Params user_id is not provided.."}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  def get_all_industries
    begin
      industry = []
      @industry = Industry.all
      unless @industry.blank?
        @industry.each do |ind|
          industry << {:id => ind.id, :title => ind.title.present? ? ind.title : ""}
        end
      end
      return render :json => {:success => "true", :industry => industry}
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  def get_all_event_types
    begin
      event_types = []
      @event_types = EventType.all
      unless @event_types.blank?
        @event_types.each do |event|
          event_types << {:id => event.id, :name => event.name.present? ? event.name : ""}
        end
      end
      return render :json => {:success => "true", :event_types => event_types}
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end


  end


  def get_user_profile
    begin
      @jobs = @user.jobs.order("updated_at DESC")
      all_purchazes = []
      unless @jobs.blank?
        @jobs.each do |a|
          cel_user = User.find(a.celebrity_id)
          industry = Industry.find(cel_user.celebrity.industry_id) if cel_user.present? && cel_user.celebrity.present?
          status = ""
          if a.status == "completed"
            status = "completed"
            elsif a.status == "admin_rejected_job" || a.status == "celebrity_video_rejected"
              status = "Rejected"
            elsif a.status == "celebrity_video_completed"
              status = "Accepted"
            else
              status = "Pending"
          end
          all_purchazes << {:job_id => a.id, :celebrity_first_name => cel_user.first_name.present? ? cel_user.first_name : "", :celebrity_last_name => cel_user.last_name.present? ? cel_user.last_name : "", :url => cel_user.celebrity.present? ? cel_user.celebrity.avatar.url : "", :status => status, :created => a.created_at.present? ? a.created_at.strftime("%-m/%-d/%Y") : "",:deadline => a.deadline.present? ? a.deadline.strftime("%-m/%-d/%Y") : "", :video_url => (a.video_url.present? ? a.video_url : ""), :industry => industry.present? ? industry.title : ""}
        end
      end
      return render :json => {:success => "true", :all_purchazes => all_purchazes}
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end


  end


  def search_celebrity_by_name_or_industry
    begin
      if params[:search_name].present? && params[:price].blank? && params[:industry].blank? && params[:rating].blank?
        celebrity_array = []
        if !params[:search_name].nil?
          @industry = Industry.where('title ilike ?', params[:search_name]).first
          if (@industry.present? && @industry != nil)
            ind = @industry.id
          else
            ind = 0
          end
          @celebrity_users = User.search_celeb_by_name_or_industry(params[:search_name], ind) #.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
          @celebrity_users = @celebrity_users.where(:is_active => true, :is_deleted => false)
          unless @celebrity_users.blank?
            @celebrity_users.each do |user|
              industry = Industry.find(user.celebrity.industry_id) if user.celebrity.present?
              celebrity_array << {:id => user.id, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "", :industry => industry.present? ? industry.title : ""} if user.away_mode == false
            end
            return render :json => {:success => "true", :celebrity_array => celebrity_array}
          else
            return render :json => {:success => "false", :message => "No Record Found!...", :celebrity_array => celebrity_array}
          end
        else
          return render :json => {:success => "false", :message => "Missings Params,search params does not exist"}
        end
        #return render :json => {:success => "false", :message => "name present and param 1 and param 2 param 3 not present"}
      elsif params[:search_name].blank? && (params[:price].present? || params[:industry].present?)
        celebrity_array = []
        @celebrity_users = User.search_celeb_by_name_and_industry(nil, params[:industry].present? ? params[:industry] : 0) #.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
        @celebrity_users = @celebrity_users.where(:is_active => true, :is_deleted => false)
        unless @celebrity_users.blank?
          @celebrity_users.each do |user|
            industryy = Industry.find(user.celebrity.industry_id) if user.celebrity.present?
            if params[:price].present?
              if (user.celebrity.default_rate <= params[:price].to_f)
                industry = Industry.find(user.celebrity.industry_id) if user.celebrity.present?
                celebrity_array << {:id => user.id, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "", :industry => industry.present? ? industry.title : ""}
              end
            end
            celebrity_array << {:id => user.id, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "", :industry => industryy.present? ? industryy.title : ""} if params[:price].blank?
          end
          return render :json => {:success => "true", :celebrity_array => celebrity_array}
        else
          return render :json => {:success => "false", :message => "No Record Found!...", :celebrity_array => celebrity_array}
        end
        #return render :json => {:success => "false", :message => "Both paramsn ot present"}
      elsif params[:search_name].present? && (params[:price].present? || params[:industry].present?)
        celebrity_array = []
        @celebrity_users = User.search_celeb_by_name_and_industry(params[:search_name], params[:industry].present? ? params[:industry] : 0) #.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
        @celebrity_users = @celebrity_users.where(:is_active => true, :is_deleted => false)
        unless @celebrity_users.blank?
          @celebrity_users.each do |user|
            if params[:price].present?
              if (user.celebrity.default_rate <= params[:price].to_f)
                industry = Industry.find(user.celebrity.industry_id) if user.celebrity.present?
                celebrity_array << {:id => user.id, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "", :industry => industry.present? ? industry.title : ""}
              end
            end
            celebrity_array << {:id => user.id, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : ""} if params[:price].blank?
          end
          return render :json => {:success => "true", :celebrity_array => celebrity_array}
        else
          return render :json => {:success => "false", :message => "No Record Found!...", :celebrity_array => celebrity_array}
        end
      else
        celebrity_array = []
        @celebrity_users = User.all_non_deleted_celebrities #.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
        unless @celebrity_users.blank?
          @celebrity_users.each do |user|
            industry = Industry.find(user.celebrity.industry_id) if user.celebrity.present?
            celebrity_array << {:id => user.id, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "", :industry => industry.present? ? industry.title : ""}
          end
          return render :json => {:success => "true", :celebrity_array => celebrity_array}
        else
          return render :json => {:success => "false", :message => "No Record Found!...", :celebrity_array => celebrity_array}
        end
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  #def search_filtered_celebrities
  #  puts "_________________________Search Filtered Celebrities_________________________"
  #  puts "000000000000000000000", params.inspect
  #  begin
  #    #params[:price] = "200"
  #    celebrity_array = []
  #    if params[:price].present?
  #      @celebrity_users = User.all_non_deleted_celebrities #.all.where('first_name like ? OR last_name like ?', "%#{params[:search]}%", " #{params[:search].upcase}")
  #      unless @celebrity_users.blank?
  #        @celebrity_users.each do |user|
  #          if (user.celebrity.default_rate <= params[:price].to_f)
  #            celebrity_array << {:id => user.id, :first_name => user.first_name, :last_name => user.last_name, :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : ""}
  #          end
  #        end
  #        return render :json => {:success => "true", :celebrity_array => celebrity_array}
  #      else
  #        return render :json => {:success => "false", :message => "No Record Found!...", :celebrity_array => celebrity_array}
  #      end
  #    else
  #      return render :json => {:success => "false", :message => "Missings Params,search params does not exist"}
  #    end
  #  rescue Exception => e
  #    return render :json => {:success => "false", :message => "#{e.message}"}
  #  end
  #end

  def create_transactions
    #params[:email] = ""
    #params[:password] = ""
    #params[:device_token] = ""
    #params[:cvv] = ""
    #params[:credit_card_number] = ""
    #params[:expiration_date] = ""
    #params[:cardholder_name] = ""
    #params[:message_for] = ""
    #params[:pronounce_like] = ""
    #params[:event_type_id] =
    #params[:message_details] = ""
    #params[:celebrity_id] =
    #params[:is_gift] = 1
    #params[:user_id] = 58
    ActiveRecord::Base.transaction do |t|
      begin
        unless params[:user][:email].blank? || params[:user][:password].blank?
        puts "00000000000000000000000000000000"
        puts "00000000000000000000000000000000",params[:login] == true
        puts "00000000000000000000000000000000",params[:login] == false
        puts "00000000000000000000000000000000",params[:login] == "0"
        puts "00000000000000000000000000000000",params[:login] == "1"
        puts "00000000000000000000000000000000",params[:login]
        puts "00000000000000000000000000000000"
          @already_user = User.where(:email => params[:user][:email]).first
        puts "----------------------------------------------",@already_user.inspect
          if @already_user.blank? && params[:login] == "0"
            puts "1111111111111111111111111111111"
            random_str = SecureRandom.hex
            @user = User.new(:email => params[:user][:email], :password => params[:user][:password], :user_type => "user", :device_token => params[:device_token], :session_token => random_str, :first_name => params[:cardholder_name], :last_name => params[:cardholder_name])
            if @user.save
              rand = 100 + rand(900)
              @user_job = Job.new(:message_for => params[:user][:job][:message_for], :pronounce_like => params[:user][:job][:pronounce_like], :is_gift => params[:user][:job][:is_gift], :event_type_id => params[:user][:job][:event_type_id], :message_details => params[:user][:job][:message_details], :deadline => params[:user][:job][:deadline], :status => "pending", :celebrity_id => params[:user][:job][:celebrity_id], :user_id => @user.id)
              if @user_job.save
                @user_job.update_attributes(:customer_job_id => "100" + @user_job.id.to_s + rand.to_s)
                puts "22222222222222222222222222222222222222222"
                @user_c = User.find(params[:user][:job][:celebrity_id])
                @celebrity = @user_c.celebrity #Celebrity.find(params[:user][:job][:celebrity_id]) if params[:user][:job][:celebrity_id].present?
                create_customer_on_braintree(@user)
                create_tr(params[:cardholder_name], params[:credit_card_number], params[:cvv], params[:expiration_date], @user, @user_job, @celebrity)
              end
            else
              return render :json => {:success => "false", :message => @user.errors.messages}
            end
          elsif @already_user.blank? && params[:login] == "1"
            puts "33333333333333333333333333"
            return render :json => {:success => "false", :message => "No user found with provided email."}
          elsif @already_user.present? && params[:login] == "0"
            puts "32132132132132132132132132132132132"
            return render :json => {:success => "false", :message => "Email already exist."}
          elsif @already_user.present? && params[:login] == "1"
            puts "//////////////////////////////////////////////////////////////"
            if @already_user.present? && @already_user.valid_password?(params[:user][:password])
              # puts "*************************************",resource.inspect
              random_str = SecureRandom.hex
              puts "*************************************"
              @already_user.update_attributes(:device_token => params[:device_token], :session_token => random_str)
              @user = @already_user
              puts "444444444444444444444444444444", @user.inspect
              rand = 100 + rand(900)
                          @user_job = Job.new(:message_for => params[:user][:job][:message_for], :pronounce_like => params[:user][:job][:pronounce_like], :is_gift => params[:user][:job][:is_gift], :event_type_id => params[:user][:job][:event_type_id], :message_details => params[:user][:job][:message_details], :deadline => params[:user][:job][:deadline], :status => "pending", :celebrity_id => params[:user][:job][:celebrity_id], :user_id => @user.id)
                          if @user_job.save
                            @user_job.update_attributes(:customer_job_id => "100" + @user_job.id.to_s + rand.to_s)
                            puts "555555555555555555555555555555555555555"
                            puts "1010101010101010101010", @user_job.inspect
                            @user_c = User.find(params[:user][:job][:celebrity_id])
                            @celebrity = @user_c.celebrity #Celebrity.find(params[:user][:job][:celebrity_id]) if params[:user][:job][:celebrity_id].present?
                            @celebrity = @user_c.celebrity #Celebrity.find(params[:user][:job][:celebrity_id]) if params[:user][:job][:celebrity_id].present?
                            puts "11 11 11 11 11 11 11 11 11 11 11 11 ", @celebrity.inspect
                            create_tr(params[:cardholder_name], params[:credit_card_number], params[:cvv], params[:expiration_date], @user, @user_job, @celebrity)

                          else
                            return render :json => {:success => "false", :message => @user_job.errors.messages}
                          end
            else
              render :json => {:success => "false", :errors => "Oops! Something is missing. Your e-mail or password may not
              have been typed in properly."}
            end
            return render :json => {:success => "false", :message => "email already exists"}
          end
          puts "77777777777777777777777777777777777777777777"
        else
          puts "66666666666666666666666666666666666666666666666666666"
          #return render :json => {:success => "false", :message => "Missing Parameters"} if params[:user_id].blank?
          if params[:user_id].present?# && params[:login] == true
            puts "777777777777777777777777777777777777777"
            @user = User.find(params[:user_id])
            puts "99999999999999999999", @user.inspect
            rand = 100 + rand(900)
            @user_job = Job.new(:message_for => params[:user][:job][:message_for], :pronounce_like => params[:user][:job][:pronounce_like], :is_gift => params[:user][:job][:is_gift], :event_type_id => params[:user][:job][:event_type_id], :message_details => params[:user][:job][:message_details], :deadline => params[:user][:job][:deadline], :status => "pending", :celebrity_id => params[:user][:job][:celebrity_id], :user_id => @user.id)
            if @user_job.save
              @user_job.update_attributes(:customer_job_id => "100" + @user_job.id.to_s + rand.to_s)
              puts "1010101010101010101010", @user_job.inspect
              @user_c = User.find(params[:user][:job][:celebrity_id])
              @celebrity = @user_c.celebrity #Celebrity.find(params[:user][:job][:celebrity_id]) if params[:user][:job][:celebrity_id].present?
              puts "11 11 11 11 11 11 11 11 11 11 11 11 ", @celebrity.inspect
              create_tr(params[:cardholder_name], params[:credit_card_number], params[:cvv], params[:expiration_date], @user, @user_job, @celebrity)
            else
              return render :json => {:success => "false", :message => @user_job.errors.messages}
            end
          else
            render :json => {:success => "false", :message => "user id is not provided ..."}
          end
        end
      rescue Exception => e
        #render :json => {:success => "false", :message => "#{e.message}"}
        raise ActiveRecord::Rollback
      end
    end
  end

  def create_tr(name, number, cvv, expiry, user, job, celebrity)
    puts "///////////////////////////////////////////////////////////",name.inspect
    puts "///////////////////////////////////////////////////////////",number.inspect
    puts "///////////////////////////////////////////////////////////",cvv.inspect
    puts "///////////////////////////////////////////////////////////",expiry.inspect
    puts "///////////////////////////////////////////////////////////",user.inspect
    puts "///////////////////////////////////////////////////////////",celebrity.inspect
    puts "///////////////////////////////////////////////////////////",job.inspect
    @event = EventType.find(job.event_type_id)
    result = Braintree::Transaction.sale(
        :customer_id => user.customer_id,
        :amount => celebrity.default_rate.present? ? celebrity.default_rate : "0",
        :credit_card => {
            :number => number,
            :expiration_date => expiry,
            :cardholder_name => name,
            :cvv => cvv
        },
        #..............................
        :custom_fields => {
            agentcode: "0",
            customerkey: user.customer_id,
            celebritykey: celebrity.user.merchant_id,
            customername: user.first_name.present? ? user.first_name : "no name provided",
            celebrityname: celebrity.user.full_name.present? ? celebrity.user.full_name : "no name provided",
            recipient: job.message_for,
            pronounced: job.pronounce_like,
            deadline: job.deadline,
            instructions: job.message_details,
            public: job.is_public,
            type: @event.present? ? @event.name : ""
        },
        #..............................
        :options => {
            :submit_for_settlement => true
        })
    if result.success?
puts "8888888888888888888888888888888888888888888",result.inspect
      @history = TransactionHistory.create(:transaction_id => result.transaction.id, :transaction_type => result.transaction.type, :status => result.transaction.status, :transaction_amount => celebrity.default_rate.present? ? celebrity.default_rate : "0", :customer_id => @user.customer_id, :user_id => user.id, :job_id => job.id)
      celeb = User.find(job.celebrity_id)
      if celeb.present? && user.present? && job.present?
      ContactMailer.send_email_on_payment_success(user,celeb,job).deliver
      end
      #if (celebrity.user.device_token.present? && celebrity.user.push_notification == true)
      #  message = "#{user.full_name} offers you to create a video for him."
      #  send_push_notification_to_user(celebrity.user, message)
      #end
puts "99999999999999999999999999999999999999999"
      render :json => {:success => "true", :user => {:id => user.id, :payment_flag => user.payment_by_check, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :email => user.email.present? ? user.email : "", :user_type => user.user_type, :token => user.session_token}, :job => {:id => job.id, :delivery_date => job.delivery_date.present? ? job.delivery_date : "", :status => job.status, :video_url => (job.status=="completed" ? job.video_url : ""), :order_date => job.created_at.present? ? job.created_at.strftime("%-m/%-d/%Y") : ""}, :message => "transaction successfull"} #, :result => result, :message => "You have purchased '#{pro.title.present? ? pro.title.to_s : ""}' from #{pro.user.present? ? pro.user.name : ""} for $ #{pro.price.present? ? pro.price.to_f : ""}"}
puts "1010101010101010101010101010101010101010101"
      return
    else
      render :json => {:success => "false", :message => result.message}
      raise ActiveRecord::Rollback
      return
    end
  end

  def get_user_purchazes
    if @user.present?
      @jobs = @user.jobs.where("status != ?", "incomplete").order("updated_at DESC")
      ordered_jobs = []
      unless @jobs.blank?
        @jobs.each do |job|
          @celebrity_user = User.find(job.celebrity_id)
          ordered_jobs << {:id => job.id, :celebrity_first_name => @celebrity_user.first_name, :celebrity_last_name => @celebrity_user.last_name, :about_me => @celebrity_user.celebrity.present? ? @celebrity_user.celebrity.about_me : "", :delivery_date => job.delivery_date.present? ? job.delivery_date : "", :status => job.status, :video_url => (job.status=="completed" ? job.video_url : ""), :order_date => job.created_at.present? ? job.created_at.strftime("%-m/%-d/%Y") : "",:deadline => job.deadline.present? ? job.deadline.strftime("%-m/%-d/%Y") : ""}
        end
        render :json => {:success => "false", :message => "user does not exists", :ordered_jobs => ordered_jobs}

      else
        render :json => {:success => "false", :message => "user does not exists", :ordered_jobs => ordered_jobs}
      end

    else
      render :json => {:success => "false", :message => "user does not exists"}
    end

  end

  def get_customer_order_details
    # some test here
    begin
      if @user.present?
        # params[:job_id] = 1
        job = @user.jobs.find(params[:job_id])
        usr = User.find(job.celebrity_id)
        industry = Industry.find(usr.celebrity.industry_id) if usr.celebrity.present?
        if job.present?
          job_detail = []
          event = EventType.find(job.event_type_id)
          job_detail << {:id => job.id, :video_for => job.message_for, :pronounce_like => job.pronounce_like, :message_type => event.name, :is_gift => job.is_gift, :message_details => job.message_details,:deadline => job.deadline.present? ? job.deadline.strftime("%-m/%-d/%Y") : "", :status => job.status, :created_at => job.created_at.present? ? job.created_at.strftime("%-m/%-d/%Y") : "", :video_url => (job.status == 'completed' ? job.video_url : ""),:first_name => usr.first_name.present? ? usr.first_name : "", :last_name => usr.last_name.present? ? usr.last_name : "",:user_type => usr.user_type, :url => usr.celebrity.present? ? usr.celebrity.avatar.url : "",:industry => industry.present? ? industry.title : ""}
          render :json => {:success => "true", :job_detail => job_detail}
        else
          render :json => {:success => "false", :message => "Job Does Not Exist."}
        end
      else
        render :json => {:success => "false", :message => "Authentication Error, Celebrity User not Founf"}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end


  def update_customer_order_details
    begin
      # params[:job_id] = 1
      # params[:message_for] = "updated"
      # params[:pronounce_like] = "updated"
      # params[:event_type_id] = 2
      # params[:is_gift] = false
      # params[:message_details] = "updated details"
      # params[:deadline] = "2015-08-28 00:00:00"
      if @user.present?
        job = @user.jobs.find(params[:job_id])
        if job.present?
          if job.update_attributes(:message_for => params[:message_for], :pronounce_like => params[:pronounce_like], :event_type_id => params[:event_type_id], :is_gift => params[:is_gift],:deadline => params[:deadline], :message_details => params[:message_details])
            job_detail = []
            event = EventType.find(job.event_type_id)
            job_detail << {:id => job.id, :video_for => job.message_for, :pronounce_like => job.pronounce_like, :message_type => event.name, :is_gift => job.is_gift, :message_details => job.message_details,:deadline => job.deadline.present? ? job.deadline.strftime("%-m/%-d/%Y") : "", :status => job.status, :created_at => job.created_at.present? ? job.created_at.strftime("%-m/%-d/%Y") : ""}
            render :json => {:success => "true", :job_detail => job_detail}
          else
            render :json => {:success => "false", :message => "try agin"}
           end
          else
          render :json => {:success => "false", :message => "Job Does Not Exist."}
        end
      else
        render :json => {:success => "false", :message => "Authentication Error, Celebrity User not Founf"}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  def check_session_create
    params[:token] = "9a0ca3b42e0f7e1fdf198802299e75b8" if Rails.env == "development"
    if params[:token].present?
      @user = User.find_by_session_token(params[:token])
      if @user.present?
        return true
      else
        render :json => {:success => "false", :errors => " authentication failed.."}
      end
    else
      render :json => {:success => "false", :errors => " authentication failed.."}
    end
  end


  #_______________________________________________________________________________________________________
  #______________________________WEB SERVICES FOR CELEBRITIES_____________________________________________
  #_______________________________________________________________________________________________________
  def get_pending_or_completed_jobs_of_celebrity
    begin
      if @user.present?
        if params[:job_status] == "pending"
          @pending_jobs = Job.all.where(:status => "admin_approved_job", :celebrity_id => @user.id).order("updated_at DESC")
          jobs = []
          if @user.celebrity.video_url.blank?
            jobs << {:job_id => 000, :job_message_for => "Introduce Yourself", :job_date => "Record a brief Video", :job_type => "", :job_status => "", :pronounce_like => "", :is_gift => true, :message_details => "", :url => "",:deadline => ""}
          end
          @pending_jobs.each do |a|
            event = EventType.find(a.event_type_id)
            jobs << {:job_id => a.id, :job_type => event.name, :job_status => a.status, :job_message_for => a.message_for, :pronounce_like => a.pronounce_like, :is_gift => a.is_gift, :message_details => a.message_details, :job_date => a.created_at.present? ? a.created_at.strftime("%-m/%-d/%Y") : "", :url => a.status == "completed" ? a.video_url : "",:deadline => a.deadline.present? ? a.deadline.strftime("%-m/%-d/%Y") : ""}
          end
          render :json => {:success => "true", :jobs => jobs}
        elsif params[:job_status] == "completed"
          @completed_jobs1 = Job.all.where(:status => "celebrity_video_completed", :celebrity_id => @user.id).order("updated_at DESC")
          #@completed_jobs2 = Job.all.where(:status => "celebrity_video_completed", :celebrity_id => @user.id)
          jobs = []
          @completed_jobs = @completed_jobs1 if @completed_jobs1.present? #@completed_jobs1 + @completed_jobs2
          if @user.celebrity.video_url.present? && @user.celebrity.is_video_verified == true
            jobs << {:job_id => 000, :job_message_for => "Introduce Yourself", :job_date => "Record a brief Video", :job_type => "", :job_status => "", :pronounce_like => "", :is_gift => true, :message_details => "", :url => @user.celebrity.video_url, :job_status => "completed",:deadline => ""}
          end
          unless @completed_jobs.blank?
          @completed_jobs.each do |a|
            event = EventType.find(a.event_type_id)
            jobs << {:job_id => a.id, :job_type => event.name, :job_status => a.status, :job_message_for => a.message_for, :pronounce_like => a.pronounce_like, :is_gift => a.is_gift, :message_details => a.message_details, :job_date => a.created_at.present? ? a.created_at.strftime("%-m/%-d/%Y") : "", :completed_at => a.updated_at.present? ? a.updated_at.strftime("%-m/%-d/%Y") : "", :url => a.status == "completed" ? a.video_url : "",:deadline => a.deadline.present? ? a.deadline.strftime("%-m/%-d/%Y") : ""}
          end
          end
          render :json => {:success => "true", :jobs => jobs}
        elsif params[:job_status] == "delivered"
          @completed_jobs1 = Job.all.where(:status => "completed", :celebrity_id => @user.id).order("updated_at DESC")
          #@completed_jobs2 = Job.all.where(:status => "celebrity_video_completed", :celebrity_id => @user.id)
          jobs = []
          @completed_jobs = @completed_jobs1 if @completed_jobs1.present? #@completed_jobs1 + @completed_jobs2
          if @user.celebrity.video_url.present? && @user.celebrity.is_video_verified == true
            jobs << {:job_id => 000, :job_message_for => "Introduce Yourself", :job_date => "Record a brief Video", :job_type => "", :job_status => "", :pronounce_like => "", :is_gift => true, :message_details => "", :url => @user.celebrity.video_url, :job_status => "completed",:deadline => ""}
          end
          unless @completed_jobs.blank?
          @completed_jobs.each do |a|
            event = EventType.find(a.event_type_id)
            jobs << {:job_id => a.id, :job_type => event.name, :job_status => a.status, :job_message_for => a.message_for, :pronounce_like => a.pronounce_like, :is_gift => a.is_gift, :message_details => a.message_details, :job_date => a.created_at.present? ? a.created_at.strftime("%-m/%-d/%Y") : "", :completed_at => a.updated_at.present? ? a.updated_at.strftime("%-m/%-d/%Y") : "", :url => a.status == "completed" ? a.video_url : "",:deadline => a.deadline.present? ? a.deadline.strftime("%-m/%-d/%Y") : ""}
          end
          end
          render :json => {:success => "true", :jobs => jobs}
        else
          jobs = []
          render :json => {:success => "true", :jobs => jobs}
        end

      else
        render :json => {:success => "false", :message => "Authentication Error, Celebrity User not Founf"}
      end

    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  #def get_pending_jobs_of_celebrity
  #  params[:user_id] = "15"
  #  @user = User.find(params[:user_id])
  #  begin
  #    if @user.present?
  #
  #      @pending_jobs = Job.all.where(:status => "pending", :celebrity_id => @user.id)
  #      pending_jobs = []
  #      @pending_jobs.each do |a|
  #        event = EventType.find(a.event_type_id)
  #        pending_jobs << {:job_id => a.id, :job_type => event.name, :job_status => a.status, :job_message_for => a.message_for, :job_date => a.created_at.strftime("%-m/%-d/%Y")}
  #      end
  #      render :json => {:success => "true", :pending_jobs => pending_jobs}
  #    else
  #      render :json => {:success => "false", :message => "Authentication Error, Celebrity User not Founf"}
  #    end
  #
  #  rescue Exception => e
  #    return render :json => {:success => "false", :message => "#{e.message}"}
  #  end
  #
  #end
  #
  #def get_completed_jobs_of_celebrity
  #  begin
  #    if @user.present?
  #
  #      @pending_jobs = Job.all.where(:status => "completed", :celebrity_id => @user.id)
  #      pending_jobs = []
  #      @pending_jobs.each do |a|
  #        event = EventType.find(a.event_type_id)
  #        pending_jobs << {:job_id => a.id, :job_type => event.name, :job_status => a.status, :job_message_for => a.message_for, :job_date => a.created_at.strftime("%-m/%-d/%Y"), :completed_at => a.updated_at.strftime("%-m/%-d/%Y")}
  #      end
  #      render :json => {:success => "true", :pending_jobs => pending_jobs}
  #    else
  #      render :json => {:success => "false", :message => "Authentication Error, Celebrity User not Founf"}
  #    end
  #
  #  rescue Exception => e
  #    return render :json => {:success => "false", :message => "#{e.message}"}
  #  end
  #
  #end

  def get_job_details

    begin
      job = Job.find(params[:job_id])
      usr = User.find(job.celebrity_id)
      industry = Industry.find(usr.celebrity.industry_id) if usr.celebrity.present?
      if job.present?
        job_detail = []
        event = EventType.find(job.event_type_id)
        job_detail << {:id => job.id, :video_for => job.message_for, :pronounce_like => job.pronounce_like, :message_type => event.name, :is_gift => job.is_gift, :message_details => job.message_details, :status => job.status, :created_at => job.created_at.present? ? job.created_at.strftime("%-m/%-d/%Y") : "",:deadline => job.deadline.present? ? job.deadline.strftime("%-m/%-d/%Y") : "",:first_name => usr.first_name.present? ? usr.first_name : "", :last_name => usr.last_name.present? ? usr.last_name : "",:user_type => usr.user_type, :url => usr.celebrity.present? ? usr.celebrity.avatar.url : "",:industry => industry.present? ? industry.title : ""}
        render :json => {:success => "true", :job_detail => job_detail}
      else
        render :json => {:success => "false", :message => "Job Does Not Exist."}
      end

    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  def get_profile_of_celebrity
    begin
      if @user.present?
        monthly = @user.celebrity.monthly_videos.present? ? @user.celebrity.monthly_videos : 0
        additional = @user.celebrity.additional_monthly_videos.present? ? @user.celebrity.additional_monthly_videos : 0
        total = monthly + additional
        remaining = get_remaining_videos(@user.id)
        return render :json => {:success => "true", :id => @user.id, :first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :email => @user.email.present? ? @user.email : "", :user_type => @user.user_type, :url => @user.celebrity.present? ? @user.celebrity.avatar.url : "", :monthly_videos => total.present? ? total : 0,:push_notification => @user.push_notification.present? ? @user.push_notification : false, :away_mode => @user.away_mode.present? ? @user.away_mode : false, :charity_rate => @user.celebrity.charity_rate.present? ? @user.celebrity.charity_rate : 0,:remaining_videos => remaining.present? ? remaining : 0,:default_monthly_inventory => "100",:default_rate => @user.celebrity.default_rate.present? ? @user.celebrity.default_rate : 0, :message => "Profile of Celebrity Get Successfully"}
      else
        return render :json => {:success => "false", :message => "Authenticate Error,Celebrity User does not exist"}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  def update_profile_of_celebrity
    begin
      if @user.present?
        push_flag = true if params[:push_notification] == "true"
        push_flag = false if params[:push_notification] == "false"
        away_flag = true if params[:away_mode] == "true"
        away_flag = false if params[:away_mode] == "false"
        if @user.celebrity.update_attributes(:monthly_videos => params[:monthly_videos].to_i,:default_rate => params[:celebvidy_rate],:charity_rate => params[:charity_rate])
          @user.update_attributes(:push_notification => push_flag,:away_mode => away_flag)
          #remaining = get_remaining_videos(@user.id)
          return render :json => {:success => "true", :message => "Profile of Celebrity Updated Successfully"}
          #return render :json => {:success => "true", :user => {:id => @user.id, :first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :email => @user.email, :user_type => @user.user_type, :url => @user.celebrity.present? ? @user.celebrity.avatar.url : "", :monthly_videos => @user.celebrity.monthly_videos.present? ? @user.monthly_videos : "", :push_notification => @user.push_notification.present? ? @user.push_notification : false, :away_mode => @user.away_mode.present? ? @user.away_mode : false, :charity_rate => @user.celebrity.charity_rate.present? ? @user.celebrity.charity_rate : "",:remaining_videos => remaining.present? ? remaining : "",:default_rate => @user.celebrity.default_rate.present? ? @user.celebrity.default_rate : "",:token => @user.session_token}, :message => "Profile of Celebrity Updated Successfully"}
        else
          return render :json => {:success => "true", :message => "Profile Does not Updated"}
        end
      else
        return render :json => {:success => "false", :message => "Authenticate Error,Celebrity User does not exist"}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  def get_remaining_videos(celebrity_id)

    s_date = Date.today
    st_date = s_date.change(:day => 1)
    e_date = Date.today
    if e_date.month == 12
      d = 1
    else
      d = e_date.month + 1
    end
    ed_date = e_date.change(:month => d , :day => 1)
    ed_date = ed_date# - 1.day
    curr = Job.where(:celebrity_id => celebrity_id, :status => 'pending', :created_at => st_date..ed_date).count
    user = User.find(celebrity_id)
    cel = user.celebrity
    unless cel.monthly_videos.blank?
      count = cel.monthly_videos - curr
      if (count <= 0)
        count = 0
      else
        count = count
      end
      return count
    end
    return 22
  end


  def update_profile_image_of_celebrity
    begin
      if @user
        if @user.celebrity.update_attributes(profile_pic_params)
          render :json => {:message => "image Updated successfully", :success => "true", :url => @user.celebrity.present? ? @user.celebrity.avatar.url : ""}
        else
          render :json => {:message => "image not updated", :success => "false"}
        end
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  def profile_pic_params
    params.permit(:avatar)
  end

  def upload_video
    puts "0000000000000000000000000000",params.inspect
    begin
      if @user
        puts "11111111111111111111111111111",params.inspect
        if params[:walkthrough] == 'true'
          @user.celebrity.update_attributes(:video_url => params[:url])
        else
          puts "2222222222222222222222222222222",params.inspect

          job = Job.find(params[:job_id])
          # transaction = TransactionHistory.where(:job_id => job.id).last
          # buffer = open("http://metrics.celebvidy.com/youtube-video?braintree_id=#{transaction.transaction_id}&youtube_id=#{params[:url].split("watch?v=")[1]}").read()
          # result = JSON.parse(buffer)
            if job.update_attributes(:video_url => params[:url])
              puts "33333333333333333333333333"
            job.update_attributes(:status => "celebrity_video_completed")
            #if (job.user.present? && job.user.device_token.present?)
            #  message = "#{@user.full_name} Accepted your offer, Your Video Is Ready..."
            #  send_push_notification(job.user, message)
            #end
            else
              puts "444444444444444444444444",params.inspect

            render :json => {:message => "video not uploaded", :success => "false"} and return
            end
        end
        puts "5555555555555555555555555555555",params.inspect

        @pending_jobs = Job.all.where(:status => "admin_approved_job", :celebrity_id => @user.id).order("updated_at DESC")
        jobs = []
        @pending_jobs.each do |a|
          event = EventType.find(a.event_type_id)
          jobs << {:job_id => a.id, :job_type => event.name, :job_status => a.status, :job_message_for => a.message_for, :pronounce_like => a.pronounce_like, :is_gift => a.is_gift, :message_details => a.message_details, :job_date => a.created_at.present? ? a.created_at.strftime("%-m/%-d/%Y") : "", :url => a.status == "completed" ? a.video_url : "",:deadline => a.deadline.present? ? a.deadline.strftime("%-m/%-d/%Y") : ""}
        end
        if @user.celebrity.video_url.blank?
          puts "6666666666666666666666666",params.inspect

          jobs << {:job_id => 000, :job_message_for => "Introduce Yourself", :job_date => "Record a brief Video", :job_type => "", :job_status => "", :pronounce_like => "", :is_gift => true, :message_details => "", :url => "",:deadline => ""}
        end
        render :json => {:message => "Video Uploaded successfully", :success => "true", :jobs => jobs}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  #def upload_video
  #  puts "_________________________Upload Video_________________________"
  #  puts "000000000000000000000", params.inspect
  #  puts "000000000000000000000", params[:job]
  #  #puts "000000000000000000000", params[:job][:video]
  #  begin
  #    if @user
  #      if params[:walkthrough] == 'true'
  #        @user.celebrity.update_attributes(:video_url => params[:url])
  #      else
  #      job = Job.find(params[:job_id])
  #      if job.update_attributes(:video_url => params[:url])
  #        job.update_attributes(:status => "celebrity_video_completed")
  #        #if (job.user.present? && job.user.device_token.present?)
  #        #  message = "#{@user.full_name} Accepted your offer, Your Video Is Ready..."
  #        #  send_push_notification(job.user, message)
  #        #end
  #      else
  #        puts "////////////////////////////////////////////",job.errors.messages
  #        render :json => {:message => "video not uploaded", :success => "false"} and return
  #      end
  #      end
  #      @pending_jobs = Job.all.where(:status => "admin_approved_job", :celebrity_id => @user.id).order("updated_at DESC")
  #      jobs = []
  #      @pending_jobs.each do |a|
  #        event = EventType.find(a.event_type_id)
  #        jobs << {:job_id => a.id, :job_type => event.name, :job_status => a.status, :job_message_for => a.message_for, :pronounce_like => a.pronounce_like, :is_gift => a.is_gift, :message_details => a.message_details, :job_date => a.created_at.strftime("%-m/%-d/%Y"), :url => a.status == "completed" ? a.video_url : ""}
  #      end
  #      if @user.celebrity.video_url.blank?
  #        jobs << {:job_id => 000, :job_message_for => "Introduce Yourself", :job_date => "Record a brief Video", :job_type => "", :job_status => "", :pronounce_like => "", :is_gift => true, :message_details => "", :url => "",:deadline => ""}
  #      end
  #      render :json => {:message => "Video Uploaded successfully", :success => "true", :jobs => jobs}
  #    end
  #  rescue Exception => e
  #    return render :json => {:success => "false", :message => "#{e.message}"}
  #  end
  #
  #end

  def video_params
    params[:job].permit(:video)
  end
  def celebrity_video_params
    params[:job].permit(:video)
  end

  def reject_job
    begin
      if @user
        job = Job.find(params[:job_id])
        if job.update_attributes(:status => "celebrity_video_rejected")
          @pending_jobs = Job.all.where(:status => "admin_approved_job", :celebrity_id => @user.id).order("updated_at DESC")
          jobs = []
          @pending_jobs.each do |a|
            event = EventType.find(a.event_type_id)
            jobs << {:job_id => a.id, :job_type => event.name, :job_status => a.status, :job_message_for => a.message_for, :pronounce_like => a.pronounce_like, :is_gift => a.is_gift, :message_details => a.message_details, :job_date => a.created_at.present? ? a.created_at.strftime("%-m/%-d/%Y") : "", :url => a.status == "completed" ? a.video_url : "",:deadline => a.deadline.present? ? a.deadline.strftime("%-m/%-d/%Y") : ""}
          end

          if job.user.device_token.present?
            message = "#{@user.full_name} rejected your offer..."
            send_push_notification_to_user(job.user, message)
          end
                      # <<James End Point Sheet Server Ping Celeb Rejected Order>>
            puts "<<James End Point Sheet Server Ping Celeb Rejected Order>>"
          # buffer = open("http://team.celebvidy.com/order-status?order_number=#{job.customer_job_id}&braintree_id=#{job.user.customer_id}&status=celeb_rejected&reason=no reason specified yet&message=optional&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
          buffer = open("http://team.celebvidy.com/order-status?order_number=#{job.customer_job_id}&braintree_id=#{job.user.customer_id}&status=celeb_rejected&reason=no&message=optional&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
            result = JSON.parse(buffer)
            puts "CELEB REJECTED ORDER????????????????????????????????????????",result
          render :json => {:success => "true", :message => "Video Offer Rejected", :jobs => jobs}
          else
          render :json => {:success => "false", :message => "Error, Not Rejected, Some Internal Error."}
        end
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  def update_push_notification
    if @user.present?
      push_flag = "true" if params[:push_notification] == "true"
      push_flag = "false" if params[:push_notification] == "false"
      if @user.update_attributes(:push_notification => push_flag)
        render :json => {:success => "true", :message => "push notification updated successfully"}
        else
          render :json => {:success => "false", :message => "push notification not updated"}
        end
    else
      render :json => {:success => "false", :message => "user does not exist"}
    end
  end

  def update_away_mode
    if @user.present?
      away_flag = "true" if params[:away_mode] == "true"
      away_flag = "false" if params[:away_mode] == "false"

      if @user.update_attributes(:away_mode => away_flag)
        render :json => {:success => "true", :message => "away mode updated successfully"}
      else
        render :json => {:success => "false", :message => "away mode not updated"}
      end
    else
      render :json => {:success => "false", :message => "user does not exist"}
    end

  end

  def update_celebvidy_rate
    if @user.present?
      if @user.celebrity.update_attributes(:default_rate => params[:celebvidy_rate])
        render :json => {:success => "true", :message => "celebvidy rate updated successfully"}
      else
        render :json => {:success => "false", :message => "away mode not updated"}
      end
    else
      render :json => {:success => "false", :message => "user does not exist"}
    end


  end

  def update_charity_rate
    if @user.present?
      if @user.celebrity.update_attributes(:charity_rate => params[:charity_rate])
        render :json => {:success => "true", :message => "charity rate updated successfully"}
      else
        render :json => {:success => "false", :message => "charity rate not updated"}
      end
    else
      render :json => {:success => "false", :message => "user does not exist"}
    end


  end

  def update_monthly_videos_count
  begin
    if @user.present?
      if @user.celebrity.update_attributes(:monthly_videos => params[:monthly_videos].to_i)
        render :json => {:success => "true", :message => "charity rate updated successfully"}
      else
        render :json => {:success => "false", :message => "charity rate not updated"}
      end
    else
      render :json => {:success => "false", :message => "user does not exist"}
    end
  rescue Exception => e
    return render :json => {:success => "false", :message => "#{e.message}"}
  end
end

  def get_profile_description_of_celebrity
     #@user = User.find(params[:id])
    begin
    if @user.present? && @user.celebrity.present?
      render :json => {:success => "true", :message => "Celebrity Profile Get Successfully", :description => @user.celebrity.present? ? @user.celebrity.description : ""}
    else
      render :json => {:success => "false", :message => "Profile Does Not Exist"}
    end
  rescue Exception => e
    return render :json => {:success => "false", :message => "#{e.message}"}
  end

end


  def update_profile_description_of_celebrity
  begin    #@user = User.find(params[:id])
    if @user.present? && @user.celebrity.present?
      @user.celebrity.update_attributes(:description => params[:user][:celebrity][:description])
      render :json => {:success => "true", :message => "Celebrity Profile Successfully Updated", :description => @user.celebrity.present? ? @user.celebrity.description : ""}
    else
      render :json => {:success => "false", :message => "Profile Does Not Exist"}
    end
  rescue Exception => e
    return render :json => {:success => "false", :message => "#{e.message}"}
  end
  end



  def get_payment_address_of_celebrity
  begin
    if @user.present? && @user.celebrity.present?
       payment_address = @user.celebrity.payment_address
       merchant_account = Braintree::MerchantAccount.find(@user.merchant_id) if @user.merchant_id.present?
       render :json => {:success => "true", :message => "Celebrity Payment Address Successfully Get", :payment_address => {:mail_to_name => (payment_address.present? && payment_address.mail_to_name.present?) ? payment_address.mail_to_name : "",:legal_name => (payment_address.present? && payment_address.legal_name.present?) ? payment_address.legal_name : "", :address => (payment_address.present? && payment_address.address.present?) ? payment_address.address : "",:city => (payment_address.present? && payment_address.city.present?) ? payment_address.city : "", :state => (payment_address.present? && payment_address.state.present?) ? payment_address.state : "", :zip_code => (payment_address.present? && payment_address.zip_code.present?) ? payment_address.zip_code : "" }, :merchant_account => {:street_address => merchant_account.present? ? merchant_account.individual_details.address.street_address : "",:city => merchant_account.present? ? merchant_account.individual_details.address.locality : "",:state => merchant_account.present? ? merchant_account.individual_details.address.region : "",:zip_code => merchant_account.present? ? merchant_account.individual_details.address.postal_code : "",:acc_num => (merchant_account.present? && merchant_account.funding_details.present? && merchant_account.funding_details.account_number_last_4.present?) ? ("*******"  + merchant_account.funding_details.account_number_last_4) : "",:routing_num => merchant_account.present? ? merchant_account.funding_details.routing_number : "", :first_name => merchant_account.present? ? merchant_account.individual_details.first_name : "", :last_name => merchant_account.present? ? merchant_account.individual_details.first_name : "" , :ssn => (merchant_account.present? && merchant_account.individual_details.present? && merchant_account.individual_details.ssn_last_4.present?) ? ("*******"  + merchant_account.individual_details.ssn_last_4) : "", :account_type => @user.account_type.present? ? @user.account_type : ""}}
    else
      render :json => {:success => "false", :message => "Profile Does Not Exist"}
    end
  rescue Exception => e
    return render :json => {:success => "false", :message => "#{e.message}"}
  end

end

  def update_payment_address_of_celebrity
  begin
    if @user.present? && @user.celebrity.present?
       if @user.celebrity.payment_address.present?
        if @user.celebrity.payment_address.update_attributes(:mail_to_name => params[:user][:celebrity][:payment_address][:mail_to_name],:legal_name => params[:user][:celebrity][:payment_address][:legal_name],:address => params[:user][:celebrity][:payment_address][:address],:city => params[:user][:celebrity][:payment_address][:city],:state => params[:user][:celebrity][:payment_address][:state],:zip_code => params[:user][:celebrity][:payment_address][:zip_code])
          if @user.update_attributes(:payment_by_check => true)
           puts "///////////////////////////////////////////////",@user.inspect
          else
            puts "*********************************************",@user.inspect
          end
        end
         payment_address = @user.celebrity.payment_address
         render :json => {:success => "true", :message => "Celebrity Payment Address Created Successfully", :payment_address => {:mail_to_name => (payment_address.present? && payment_address.mail_to_name.present?) ? payment_address.mail_to_name : "",:legal_name => (payment_address.present? && payment_address.legal_name.present?) ? payment_address.legal_name : "", :address => (payment_address.present? && payment_address.address.present?) ? payment_address.address : "",:city => (payment_address.present? && payment_address.city.present?) ? payment_address.city : "", :state => (payment_address.present? && payment_address.state.present?) ? payment_address.state : "", :zip_code => (payment_address.present? && payment_address.zip_code.present?) ? payment_address.zip_code : "" }}
       else
           PaymentAddress.create!(:celebrity_id => @user.celebrity.id,:mail_to_name => params[:user][:celebrity][:payment_address][:mail_to_name],:legal_name => params[:user][:celebrity][:payment_address][:legal_name],:address => params[:user][:celebrity][:payment_address][:address],:city => params[:user][:celebrity][:payment_address][:city],:state => params[:user][:celebrity][:payment_address][:state],:zip_code => params[:user][:celebrity][:payment_address][:zip_code])
           if @user.update_attributes(:payment_by_check => true)
            puts "///////////////////////////////////////////////",@user.inspect
           else
             puts "*********************************************",@user.inspect
           end
           payment_address = @user.celebrity.payment_address
           render :json => {:success => "true", :message => "Celebrity Payment Address Updated Successfully", :payment_address => {:mail_to_name => (payment_address.present? && payment_address.mail_to_name.present?) ? payment_address.mail_to_name : "",:legal_name => (payment_address.present? && payment_address.legal_name.present?) ? payment_address.legal_name : "", :address => (payment_address.present? && payment_address.address.present?) ? payment_address.address : "",:city => (payment_address.present? && payment_address.city.present?) ? payment_address.city : "", :state => (payment_address.present? && payment_address.state.present?) ? payment_address.state : "", :zip_code => (payment_address.present? && payment_address.zip_code.present?) ? payment_address.zip_code : "" }}
       end
      #render :json => {:success => "true", :message => "Celebrity Payment Address Successfully Get", :payment_address => {:legal_name => payment_address.legal_name.present? ? payment_address.legal_name : "", :address => payment_address.address.present? ? payment_address.address : "",:city => payment_address.city.present? ? payment_address.city : "", :state => payment_address.state.present? ? payment_address.state : "", :zip_code => payment_address.zip_code.present? ? payment_address.zip_code : "" }}
    else
      render :json => {:success => "false", :message => "Profile Does Not Exist"}
    end
  rescue Exception => e
    return render :json => {:success => "false", :message => "#{e.message}"}
  end

  end


  def update_merchant_of_celebrity_on_braintree
    begin
      if @user.present?
         if @user.merchant_id.present?
           update_merchant_on_braintree_by_celebrity(@user, params[:name_of_bank], params[:acc_num], params[:routing_num],params[:ssn],params[:street_address],params[:city],params[:state],params[:zip_code],params[:account_type])
         else
           create_merchant_on_braintree_by_celebrity(@user, params[:name_of_bank], params[:acc_num], params[:routing_num],params[:ssn],params[:street_address],params[:city],params[:state],params[:zip_code],params[:account_type])
         end
      else
        render :json => {:success => "false", :message => "User Does Not Exist."}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  def create_merchant_on_braintree_by_celebrity(user, bank_name, acc_num, rout_num, ssn,street_address,city,state,zip_code,type)
    result = Braintree::MerchantAccount.create(
        :individual => {
            :first_name => bank_name,
            :last_name => bank_name,
            :email => user.email,
            :date_of_birth => '2014-01-01',
            :ssn => ssn,
            :address => {
                :street_address => street_address.present? ? street_address : "111 Main St",
                :locality => city,
                :region => state,
                :postal_code => zip_code
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
      if user.celebrity.present?
        user.celebrity.update_attributes(:verified_account => true)
      end
        user.update_attributes(:merchant_id => result.merchant_account.id, :account_type => type)
      render :json => {:success => "true", :message => "Celebrity Details has been successfully created..."}
    else
      render :json => {:success => "false", :message => result.message }
    end
  end

  def update_merchant_on_braintree_by_celebrity(user, bank_name, acc_num, rout_num, ssn,street_address,city,state,zip_code,type)
    result = Braintree::MerchantAccount.update(
        user.merchant_id,
        :individual => {
            :first_name => bank_name,
            :last_name => bank_name,
            :email => user.email,
            #:date_of_birth => '1981-11-19',
            :ssn => ssn,
            :address => {
                :street_address => street_address.present? ? street_address : "111 Main St",
                :locality => city,
                :region => state,
                :postal_code => zip_code
            }
        },
        :funding => {
            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
            :account_number => acc_num,
            :routing_number => rout_num
        },
    )
    if result.success?
      user.celebrity.update_attributes(:verified_account => true) if user.celebrity.present?
      user.update_attributes(:merchant_id => result.merchant_account.id,:account_type => type)
      render :json => {:success => "true", :message => "Celebrity Details has been successfully Updated..."}
    else
      render :json => {:success => "false", :message => result.message }
    end
  end



  def update_email_of_celebrity
    begin

      if @user
        @already_user = User.where(:email => params[:user][:email]) if params[:user][:email].present?
        if @already_user.blank?
        if @user.update_attributes(:email => params[:user][:email])
          render :json => {:success => "true", :message => "Email Successfully Updated.", :user => {:id => @user.id, :email => @user.email.present? ? @user.email : "", :code_verify => @user.code_verify}}
        else
          render :json => {:success => "false", :message => "Oops!, Email Not Updated."}
        end
        else
          render :json => {:success => "false", :message => "Oops!, Email Already exist."}
          end
      else
        render :json => {:success => "false", :message => "User Does Not Exist."}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  def update_payment_info
    begin
      if @user
        if params[:payment_by_check].present?
         if @user.update_attributes(:payment_by_check => params[:payment_by_check])
           render :json => {:success => "true", :payment_flag => @user.payment_by_check, :message => "Successfully Updated"}
           else
             render :json => {:success => "false", :message => "Try Again!!"}
         end
        else
          render :json => {:success => "false", :message => "params[:payment_by_check] is not present"}
        end
      else
        render :json => {:success => "false", :message => "User Does Not Exist."}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end


  end




  def send_push_notification(user, message)
    #this is the main function
    if user.device_token.blank?
      return
    end
    notification = Houston::Notification.new(device: user.device_token)
    notification.sound = "sosumi.aiff"
    notification.content_available = true
    notification.custom_data = {:user_id => user.id, :first_name => user.user.first_name, :full_name => user.full_name}
    notification.alert = "#{user.full_name} : #{message}"
    #certificate = File.read("config/celebvidydevelopment.pem") if Rails.env == "development"
    certificate = File.read("config/ck_production.pem") if Rails.env == "production"
    pass_phrase = "push"
    connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase)
    #connection = Houston::Connection.new("apn://gateway.push.apple.com:2195", certificate, pass_phrase)
    connection.open
    connection.write(notification.message)
    connection.close
    puts "notification sent to user #{user.full_name} and device token is #{user.device_token}"
  end


  def get_shorten_url_of_profile
    begin
      if @user
        bitly = Bitly.new("celebvidy", "R_b3c61372ac35462694df86fb6b515098")
        u = bitly.shorten("http://stage.celebvidy.com/celebrities/#{@user.id}", :history => 1) # adds the url to the api user's history
        u.long_url #=> "http://www.google.com"
        u.short_url #=> "http://bit.ly/Ywd1"
        u.bitly_url #=> "http://bit.ly/Ywd1"
        u.jmp_url #=> "http://j.mp/Ywd1"
        u.user_hash #=> "Ywd1"
        u.hash #=> "2V6CFi"
        u.info #=> a ruby hash of the JSON returned from the API
        u.stats #=> a ruby hash of the JSON returned from the API
        return render :json => {:success => "true", :long_url => u.long_url, :short_url => u.short_url }#, :jmp_url => u.jmp_url, :bitly_user_hash => u.user_hash, :bitly_hash => u.hash, :bitly_info => u.info, :bitly_stats => u.stats
        #return render :json => {:success => "true", :bitly => bitly, :long => u.long_url, :short => u.short_url, :bitly_url => u.bitly_url, :jmp_url => u.jmp_url, :bitly_user_hash => u.user_hash, :bitly_hash => u.hash, :bitly_info => u.info, :bitly_stats => u.stats}
      else
        render :json => {:success => "false", :message => "User Does Not Exist."}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  def check_device_code
    begin
      @code = Code.where(:device_token => params[:device_token], :is_consumed => true).first
      if @code.present?
        return render :json => {:success => "true", :message => "Agent Code Verified", :code_verify => "true"}
      else
        return render :json => {:success => "true", :message => "Agent Code Not Verified", :code_verify => "false"}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  def submit_agent_code
    begin
      if params[:agent_code].present?
      buffer = open("http://metrics.celebvidy.com/celebrity-verification?agent_code=#{params[:agent_code].upcase}").read()
      result = JSON.parse(buffer)
      if result["verified"] == true
        Code.create(:code_name => params[:agent_code].upcase,:is_consumed => true, :consumed_on => Time.now, :device_token => params[:device_token])
        return render :json => {:success => "true", :message => "Agent Code Verified", :code_verify => "true"}
      else
        return render :json => {:success => "true", :message => "ERROR!!!", :code_verify => "false"}
      end
      else
        return render :json => {:success => "false", :message => "Agent Code Is Required"}
        end
#..............................................
#@code = Code.where(:code_name => params[:agent_code].upcase, :is_consumed => false).first
#  if @code.present?
#    if @code.update_attributes(:is_consumed => true, :consumed_on => Time.now, :device_token => params[:device_token])
#      return render :json => {:success => "true", :message => "Agent Code Verified", :code_verify => "true"}
#    else
#      return render :json => {:success => "false", :message => "ERROR!!!", :code_verify => "false"}
#    end
#    else
#    return render :json => {:success => "true", :message => "Agent Code Not Verified", :code_verify => "false"}
#  end
#..............................................
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end
  end

  #def submit_agent_code
  #  puts "---------------------submit_agent_code---------------------"
  #  puts "---------------------submit_agent_code---------------------"
  #  begin
  #
  #        buffer = open("http://metrics.celebvidy.com/celebrity-verification?agent_code=#{params[:agent_code].upcase}").read
  #        result = JSON.parse(buffer)
  #        #uri.open {|f|
  #        puts "00000000000000000000000000000",result
  #        if result.verified == true
  #          Code.create(:code_name => params[:agent_code].upcase,:is_consumed => true, :consumed_on => Time.now, :device_token => params[:device_token])
  #          return render :json => {:success => "true", :message => "Agent Code Verified", :code_verify => "true"}
  #        else
  #          return render :json => {:success => "true", :message => "ERROR!!!", :code_verify => "false"}
  #        end
  #
  #  end
  #end

  #def submit_agent_code
  #  begin
  #    if @user
  #      if @user.agent_code == params[:agent_code].upcase
  #        @user.update_attributes(:code_verify => true)
  #        if (@user.celebrity.present? && @user.celebrity.industry_id.present?)
  #        industry = Industry.find(@user.celebrity.industry_id)
  #        end
  #        monthly = @user.celebrity.monthly_videos.present? ? @user.celebrity.monthly_videos : 0
  #        additional = @user.celebrity.additional_monthly_videos.present? ? @user.celebrity.additional_monthly_videos : 0
  #        total = monthly + additional
  #        remaining = get_remaining_videos(@user.id)
  #        return render :json => {:success => "true", :message => "Agent Code Verified", :code_verify => "true", :user => {:id => @user.id, :twitter_user => @user.twitter_id.present? ? true : false, :first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :email => @user.email.present? ? @user.email : "", :user_type => @user.user_type, :url => @user.celebrity.present? ? @user.celebrity.avatar.url : "", :token => @user.session_token, :verified_account => @user.celebrity.present? ? @user.celebrity.verified_account : false, :code_verify => @user.code_verify}, :celebrity => {:id => @user.id, :first_name => @user.first_name.present? ? @user.first_name : "", :last_name => @user.last_name.present? ? @user.last_name : "", :email => @user.email.present? ? @user.email : "", :user_type => @user.user_type, :url => (@user.celebrity.present? && @user.celebrity.avatar.present?) ? @user.celebrity.avatar.url : "", :monthly_videos => total.present? ? total : 0,:push_notification => @user.push_notification.present? ? @user.push_notification : false, :away_mode => @user.away_mode.present? ? @user.away_mode : false, :charity_rate => @user.celebrity.charity_rate.present? ? @user.celebrity.charity_rate : 0,:remaining_videos => remaining.present? ? remaining : 0,:default_rate => @user.celebrity.default_rate.present? ? @user.celebrity.default_rate : 0 }, :industry => industry.present? ? industry.title : ""}
  #        #return render :json => {:success => "true", :message => "Agent Code Verified", :code_verify => "false"}
  #      else
  #        return render :json => {:success => "true", :message => "Agent Code Not Verified", :code_verify => "false"}
  #      end
  #    else
  #      render :json => {:success => "false", :message => "User Does Not Exist."}
  #    end
  #  rescue Exception => e
  #    return render :json => {:success => "false", :message => "#{e.message}"}
  #  end
  #end

  def check_twitter_celebrity

    begin
      if params[:user][:twitter_id].present?
        @already_user = User.where(:twitter_id => params[:user][:twitter_id]).first if params[:user][:twitter_id].present?
        if @already_user.present?
          return render :json => {:success => "true", :message => "Celebrity Already Exists", :already_present => "true" }#, :jmp_url => u.jmp_url, :bitly_user_hash => u.user_hash, :bitly_hash => u.hash, :bitly_info => u.info, :bitly_stats => u.stats
        else
          return render :json => {:success => "true", :message => "ALREADY USER NOT PRESENT", :already_present => "false" }#, :jmp_url => u.jmp_url, :bitly_user_hash => u.user_hash, :bitly_hash => u.hash, :bitly_info => u.info, :bitly_stats => u.stats
        end
      else
        render :json => {:success => "false", :message => "params[:user][:twitter_id] does not exist."}
      end
    rescue Exception => e
      return render :json => {:success => "false", :message => "#{e.message}"}
    end

  end

  def push_testing
    # team.celebvidy.com/order-status?order_number=144128366432uTW6&braintree_id=23452379&status=celeb_rejected&reason=no reason specified yet&message=(optional+message)&key=492b125dbaff82d54ff0286c64980bff6465ce60
    job = Job.last
    puts "<<James End Point Sheet Server Ping Celeb Rejected Order>>"
    buffer = open("http://team.celebvidy.com/order-status?order_number=#{job.customer_job_id}&braintree_id=#{job.user.customer_id}&status=celeb_rejected&reason=no reason is specified yet&message=optional message&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
    result = JSON.parse(buffer)
    puts "CELEB REJECTED ORDER????????????????????????????????????????",result
    puts "CELEB REJECTED ORDER????????????????????????????????????????",result["success"] == true
    render :json => {:success => 'true', :message => 'Server Ping Response', :result => result["success"], :buffer => buffer}
    # @user = User.where(:email => "taha09@gmail.com").first
    # puts "+++++++++++++++++",@user.payment_by_check
    # if @user.update_attributes(:payment_by_check => true)
    # puts "*/*/*/*/*/*/*/*/*/*/******/////////*************/////////**********////////*"
    # end
    # puts "---------------------------------------------------",@user.inspect
    # user = User.where(:email => "tahir.khan@whiterabbit.is").first
    # puts "00000000000000000000000000000000000000000000000",user.valid_password?('12345678')
    # aaaaaaaaaaaaaaaaaaaaaaaaaaa
    # push_testing?user[email]="tahir.khan@whiterabbit.is"&user[password]="123456789"
    # bitly = Bitly.new("celebvidy", "R_b3c61372ac35462694df86fb6b515098")
    # puts "00000000000000000000000000000000000",bitly.inspect
    # puts "11111111111111111111111111111111111",bitly.shorten('http://www.google.com')
    # u = bitly.shorten('http://stage.celebvidy.com/celebrities/85', :history => 1) # adds the url to the api user's history
    #bitly.expand('wQaT')
    #bitly.info('http://bit.ly/wQaT')
    #bitly.stats('http://bit.ly/wQaT')
    # u.long_url #=> "http://www.google.com"
    # u.short_url #=> "http://bit.ly/Ywd1"
    # u.bitly_url #=> "http://bit.ly/Ywd1"
    # u.jmp_url #=> "http://j.mp/Ywd1"
    # u.user_hash #=> "Ywd1"
    # u.hash #=> "2V6CFi"
    # u.info #=> a ruby hash of the JSON returned from the API
    # u.stats #=> a ruby hash of the JSON returned from the API
    # u.shorten('http://www.google.com', 'keyword')
    # return render :json => {:success => "true", :long_url => u.long_url, :short_url => u.short_url }#, :jmp_url => u.jmp_url, :bitly_user_hash => u.user_hash, :bitly_hash => u.hash, :bitly_info => u.info, :bitly_stats => u.stats
    #return render :json => {:success => "true", :bitly => bitly,:long => u.long_url , :short => u.short_url , :bitly_url => u.bitly_url, :jmp_url => u.jmp_url, :bitly_user_hash => u.user_hash, :bitly_hash => u.hash, :bitly_info => u.info, :bitly_stats => u.stats}
    # params[:profile_url] = "http://abs.twimg.com/sticky/default_profile_images/default_profile_6_normal.png"
    # user = User.find(15)
    # @cel = user.celebrity
    #     avatar = URI.parse(params[:profile_url]) if params[:profile_url].present?
    # @cel.update_attributes(:avatar => avatar) if avatar.present?
    #params[:device_token] = '<af43fe13 e55d0b6f 73ac27fd 8a667a22 dbbb08ad 0c585892 1d6e5f53 cf724ad5>'
    # params[:device_token] = '<af43fe13 e55d0b6f 73ac27fd 8a667a22 dbbb08ad 0c585892 1d6e5f53 cf724ad5>'
    # if params[:device_token].present?
    #   message_count = 1
    #   notification = Houston::Notification.new(device: params[:device_token])
    #   notification.badge = message_count
    #   notification.sound = "sosumi.aiff"
    #   notification.content_available = true
    #   notification.custom_data = {:name => "tahir khan lodhi"}
    #   notification.alert = "This is sample message"
    #   certificate = File.read("config/celebvidydevelopment.pem")  if Rails.env == "development"
      # certificate = File.read("config/celebvidydevelopment.pem") if Rails.env == "production"
      # pass_phrase = "push"
      # connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase)  if Rails.env == "development"
      # connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase) if Rails.env == "production"
      # connection.open
      # connection.write(notification.message)
      # connection.close
      # render :json => {:success => 'true', :message => 'message send '}
    # else
    #   render :json => {:success => 'false', :message => 'device_id not found'}
    # end
  end
  def push_testinga
    params[:device_token] = '<af43fe13 e55d0b6f 73ac27fd 8a667a22 dbbb08ad 0c585892 1d6e5f53 cf724ad5>'

    if params[:device_token].present?
      message_count = 1
      notification = Houston::Notification.new(device: params[:device_token])
      notification.badge = message_count
      notification.sound = "sosumi.aiff"
      notification.content_available = true
      notification.custom_data = {:name => "tahir khan lodhiaaaaaaaaaaaaaaaaaa"}
      notification.alert = "This is sample message"
      # certificate = File.read("config/celebvidydevelopment.pem")  if Rails.env == "development"
      certificate = File.read("config/celebvidyproduction.pem") if Rails.env == "production"
      pass_phrase = "push"
      # connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase)  if Rails.env == "development"
      connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase) if Rails.env == "production"
      connection.open
      connection.write(notification.message)
      connection.close
      render :json => {:success => 'true', :message => 'message sendaaaaaaaaaa '}
    else
      render :json => {:success => 'false', :message => 'device_id not found'}
    end

  end
  def push_testingb
    params[:device_token] = '<af43fe13 e55d0b6f 73ac27fd 8a667a22 dbbb08ad 0c585892 1d6e5f53 cf724ad5>'

    if params[:device_token].present?
      message_count = 1
      notification = Houston::Notification.new(device: params[:device_token])
      notification.badge = message_count
      notification.sound = "sosumi.aiff"
      notification.content_available = true
      notification.custom_data = {:name => "tahir khan lodhibbbbbbbbbbbb"}
      notification.alert = "This is sample message"
      # certificate = File.read("config/celebvidydevelopment.pem")  if Rails.env == "development"
      certificate = File.read("config/ck_production.pem") if Rails.env == "production"
      pass_phrase = "push"
      # connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase)  if Rails.env == "development"
      connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase) if Rails.env == "production"
      connection.open
      connection.write(notification.message)
      connection.close
      render :json => {:success => 'true', :message => 'message sendbbbbbbbbbb '}
    else
      render :json => {:success => 'false', :message => 'device_id not found'}
    end

  end
  def push_testingc
    params[:device_token] = '<af43fe13 e55d0b6f 73ac27fd 8a667a22 dbbb08ad 0c585892 1d6e5f53 cf724ad5>'

    if params[:device_token].present?
      message_count = 1
      notification = Houston::Notification.new(device: params[:device_token])
      notification.badge = message_count
      notification.sound = "sosumi.aiff"
      notification.content_available = true
      notification.custom_data = {:name => "tahir khan lodhicccccccccccccccc"}
      notification.alert = "This is sample message"
      # certificate = File.read("config/celebvidydevelopment.pem")  if Rails.env == "development"
      certificate = File.read("config/ck_user.pem") if Rails.env == "production"
      pass_phrase = "push"
      # connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase)  if Rails.env == "development"
      connection = Houston::Connection.new("apn://gateway.sandbox.push.apple.com:2195", certificate, pass_phrase) if Rails.env == "production"
      connection.open
      connection.write(notification.message)
      connection.close
      render :json => {:success => 'true', :message => 'message sendccccccccccccccc '}
    else
      render :json => {:success => 'false', :message => 'device_id not found'}
    end

  end



  def test_service
    user = User.all.order("created_at ASC").each do |a|
      puts "00000000000000",a.first_name, a.last_name, a.full_name, a.id, a.twitter_id if a.twitter_id.present?
      end
    @user = User.where(:email => "tahir.khan@whiterabbit.is").first
    @celeb = User.find(20)
    @job = Job.find(172)
    ContactMailer.send_email_on_payment_success(@user,@celeb,@job).deliver
    #jobs = @user.jobs.last.destroy
    return render :json => {:success => "true", :message => "Successfully"}#, :user => @user, :jobs => jobs}
  end

end
