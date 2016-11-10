class Users::SessionsController < Devise::SessionsController

  layout "admin", only: [:admin_sign_in]
  require 'securerandom'
  skip_before_filter :verify_authenticity_token
# before_filter :configure_sign_in_params, only: [:create]
  def create
    puts "..............Sign In............."
    puts "......params.inspect.......", params.inspect
    puts "......request.format........", request.format
    #.........................................................
    if (params[:user_id].present? && params[:user_id] != "")

      resource = User.find(params[:user_id])

    else

      resource = warden.authenticate(:scope => resource_name, :recall => "#{controller_path}#failure")

    end
    #.........................................................
    if request.format(request) == '*/*'
      if (resource.present?)
        sign_out(current_user) if current_user.present?
        puts "..............resource.inspect.............", resource.inspect
        random_str = SecureRandom.hex
        puts "(((((((((((((random_str)))))))))))))))", random_str
        resource.update_attributes(:device_token => params[:device_token], :session_token => random_str)
        puts ".............resource.inspect.......", resource.inspect
        if params[:user_type].present?
          puts "+++++++++++++++++++++++++++++++++++", params[:user_type].inspect
          if resource.user_type == "celebrity"
            if resource.celebrity.present? && resource.celebrity.verified_account == true
              if params[:user_type] == "celebrity"
                @pending_jobs = Job.all.where(:status => "admin_approved_job", :celebrity_id => resource.id)
                jobs = []
                @pending_jobs.each do |a|
                  event = EventType.find(a.event_type_id)
                  jobs << {:job_id => a.id, :job_type => event.name, :job_message_for => a.message_for, :pronounce_like => a.pronounce_like, :is_gift => a.is_gift, :message_details => a.message_details, :job_status => a.status, :job_message_for => a.message_for, :job_date => a.created_at.present? ? a.created_at.strftime("%-m/%-d/%Y") : "", :url => a.status == "completed" ? a.video_url : "",:deadline => a.deadline.present? ? a.deadline.strftime("%-m/%-d/%Y") : ""}
                end
                if resource.celebrity.video_url.blank?
                  jobs << {:job_id => 000, :job_message_for => "Introduce Yourself", :job_date => "Record a brief Video", :job_type => "", :job_status => "", :pronounce_like => "", :is_gift => true, :message_details => "", :url => "",:deadline => ""}
                end

                return render :json => {:success => "true", :view => "", :jobs => jobs, :user => {:id => resource.id, :twitter_user => resource.twitter_id.present? ? true : false,:payment_flag => resource.payment_by_check, :first_name => resource.first_name.present? ? resource.first_name : "", :last_name => resource.last_name.present? ? resource.last_name : "", :email => resource.email.present? ? resource.email : "", :user_type => resource.user_type, :url => resource.celebrity.present? ? resource.celebrity.avatar.url : "", :token => resource.session_token, :verified_account => resource.celebrity.present? ? resource.celebrity.verified_account : false, :code_verify => resource.code_verify, :is_braintree_configured => (resource.merchant_id.present? || (resource.celebrity.present? && resource.celebrity.payment_address.present?)) ? true : false }, :message => "Celebrity Signed in Successfully!"}
              else
                return render :json => {:success => "false", :message => "You Are Not Authorized To Sign In..."}
              end
            else
              #...............................
              unless resource.celebrity.present?
                resource.celebrity.create(:about_me => "", :description => "", :default_rate => "20", :per_alphabet_rate => "0", :industry_id => "1")
              end
              if (resource.celebrity.present? && resource.celebrity.industry_id.present?)
                puts "000000000000000000000000000000000000000"
                industry = Industry.find(resource.celebrity.industry_id)
              end
              monthly = resource.celebrity.monthly_videos.present? ? resource.celebrity.monthly_videos : 0
              additional = resource.celebrity.additional_monthly_videos.present? ? resource.celebrity.additional_monthly_videos : 0
              total = monthly + additional
              remaining = get_remaining_videos(resource.id)
              return render :json => {:success => "true", :view => "profile", :message => "Celebrity Signed in Successfully..", :user => {:id => resource.id, :twitter_user => resource.twitter_id.present? ? true : false, :payment_flag => resource.payment_by_check, :first_name => resource.first_name.present? ? resource.first_name : "", :last_name => resource.last_name.present? ? resource.last_name : "", :email => resource.email.present? ? resource.email : "", :user_type => resource.user_type, :url => resource.celebrity.present? ? resource.celebrity.avatar.url : "", :token => resource.session_token, :verified_account => resource.celebrity.present? ? resource.celebrity.verified_account : false, :code_verify => resource.code_verify,:is_braintree_configured => (resource.merchant_id.present? || (resource.celebrity.present? && resource.celebrity.payment_address.present?)) ? true : false}, :celebrity => {:id => resource.id, :first_name => resource.first_name.present? ? resource.first_name : "", :last_name => resource.last_name.present? ? resource.last_name : "", :email => resource.email.present? ? resource.email : "", :user_type => resource.user_type, :url => (resource.celebrity.present? && resource.celebrity.avatar.present?) ? resource.celebrity.avatar.url : "", :monthly_videos => total.present? ? total : 0, :default_monthly_inventory => "100",:push_notification => resource.push_notification.present? ? resource.push_notification : false, :away_mode => resource.away_mode.present? ? resource.away_mode : false, :charity_rate => resource.celebrity.charity_rate.present? ? resource.celebrity.charity_rate : 0, :remaining_videos => remaining.present? ? remaining : 0, :default_rate => resource.celebrity.default_rate.present? ? resource.celebrity.default_rate : 0}, :industry => industry.present? ? industry.title : ""}
              #return render :json => {:success => "true",:view => "profile", :message => "Celebrity Signed in Successfully..", :id => resource.id, :first_name => resource.first_name.present? ? resource.first_name : "", :last_name => resource.last_name.present? ? resource.last_name : "", :token => resource.session_token, :about_me => (resource.celebrity.present? && resource.celebrity.about_me.present?) ? resource.celebrity.about_me : "", :description => (resource.celebrity.present? && resource.celebrity.description.present?) ? resource.celebrity.description : "", :default_rate => (resource.celebrity.present? && resource.celebrity.default_rate.present?) ? resource.celebrity.default_rate : "", :url => (resource.celebrity.present? && resource.celebrity.avatar.present?) ? resource.celebrity.avatar.url : "",:verified_account => resource.celebrity.present? ? resource.celebrity.verified_account : "0", :industry => industry.present? ? industry.title : ""}
              #...............................
              #return render :json => {:success => "false", :message => "Please concern your admin to verify your account..."}
            end
          else
            return render :json => {:success => "false", :message => "You Are Not Authorized To Sign In..."}
          end
        else
          if resource.user_type == "user"
            @celebrity_users = User.all_non_deleted_celebrities #.all.where(:user_type => "celebrity")
            celebrity_array = []
            @celebrity_users.each do |user|
              industry = Industry.find(user.celebrity.industry_id) if user.celebrity.present?
              celebrity_array << {:id => user.id, :first_name => user.first_name.present? ? user.first_name : "", :last_name => user.last_name.present? ? user.last_name : "", :about_me => user.celebrity.present? ? user.celebrity.about_me : "", :url => user.celebrity.present? ? user.celebrity.avatar.url : "", :industry => industry.present? ? industry.title : ""}
            end
          else
            return render :json => {:success => "false", :message => "You Are Not Authorized To Sign In..."}
          end
          return render :json => {:success => "true", :user => {:id => resource.id, :first_name => resource.first_name.present? ? resource.first_name : "", :payment_flag => resource.payment_by_check, :last_name => resource.last_name.present? ? resource.last_name : "", :email => resource.email.present? ? resource.email : "", :user_type => resource.user_type, :token => resource.session_token}, :celebrity_array => celebrity_array, :message => "User Signed in Successfully!"}
        end
        #:id => resource.id,  return render :json => {:success => "true", :message => "Logged in Successfully !", :data => after_sign_in_data(resource, random_str)}
      else
        render :json => {:success => "false", :errors => "Oops! Something is missing. Your e-mail or password may not have been typed in properly."}
      end
    else
      #self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      #sign_in(resource_name, resource)
      yield resource if block_given?
      unless resource.blank? || resource.is_celebrity
        if resource.is_admin == true
          redirect_to :controller => "admin/home", :action => "index"
          #respond_with resource, location: admin_home_index(resource)
        else
          puts "..........................$url.........................", session[:url].inspect
          if session[:url].nil?
            respond_with resource, :location => after_sign_in_path_for(resource)
          else
            redirect_to session[:url]
          end
        end
      else
        flash.clear
        flash[:error] = "User login detail not valid, Try again!"
        redirect_to '/users/sign_in'
      end
      #super
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
    ed_date = e_date.change(:month => d, :day => 1)
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


# GET /resource/sign_in
# def new
#   super
# end

# POST /resource/sign_in
# def create
#   super
# end

  def admin_sign_in
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

# POST /resource/sign_in
#  def create
#    self.resource = warden.authenticate!(auth_options)
#    set_flash_message(:notice, :signed_in) if is_flashing_format?
#    sign_in(resource_name, resource)
#    yield resource if block_given?
#    if resource.is_admin == true
#      redirect_to :controller => "admin/home", action: "index"
#      # respond_with resource, location: admin_home_index(resource)
#    else
#      respond_with resource, location: after_sign_in_path_for(resource)
#    end
#  end

# DELETE /resource/sign_out
  def destroy
    admin_path = false
    if current_user.admin?
      admin_path = true
    end
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    if admin_path
      redirect_to "/users/admin_sign_in"
    else
      respond_to_on_destroy
    end
  end

# protected

# You can put the params you want to permit in the empty array.
# def configure_sign_in_params
#   devise_parameter_sanitizer.for(:sign_in) << :attribute
# end
end
