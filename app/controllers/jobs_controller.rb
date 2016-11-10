class JobsController < ApplicationController
  # before_filter :authenticate_user!

  before_filter :auth_user

  def auth_user
    unless user_signed_in?
      session[:url] = "/jobs/#{params[:id]}"
      redirect_to new_user_registration_url
    end
    if user_signed_in?
      if current_user.admin?
        redirect_to "/admin/home/index"
      end
    end
  end

  def show
    session[:url] = nil
    @user = current_user
    @celeb = User.find_celeb(params[:id])
    @events = EventType.all
    @job = Job.new
  end

  def complete_job
    @job = Job.find(params[:id])
    @celeb = User.find(@job.celebrity_id)
    @user = User.find(@job.user_id)
    @events = EventType.all
    render 'show'
  end

  def delete_job
    @job = Job.find(params[:id])
    if @job.destroy
      if current_user.present?
        jobs = current_user.jobs.where(:status => 'incomplete')
        render :partial => '/celeberties/cart', :locals => {:jobs => jobs}
      else
        render :json => {:success => 'false', :message => "/users/sign_up"}
      end
    else
      render :text => "not deleted"
    end
  end


  def job_create
    unless params[:job][:deadline].blank?
      time = Time.strptime(params[:job][:deadline], '%m/%d/%Y')
      params[:job][:deadline] = time.strftime("%Y/%m/%d")
    end
    user = User.find(params[:job][:user_id])
    job = Job.new(job_params)
    if job.save
      rand = 100 + rand(900)
      job.update_attributes(:customer_job_id => "100" + job.id.to_s + rand.to_s)
      puts "000000000000090000",job.inspect
      celeb = User.find_celeb(params[:job][:celebrity_id])
      if job.update_attributes(video_params)
      end
      #job = current_user.jobs.last
      render :partial => 'payment_info', :locals => {:celeb => celeb, :job => job, :user => user}
    else
      render :text => "error"
    end
  end

  def video_params
    params[:job].permit(:video)
  end

  def job_update
    job = Job.find(params[:job_id])
    if job.update_attributes(job_params)
      celeb = User.find(job.celebrity_id)
      render :partial => 'payment_info', :locals => {:celeb => celeb, :job => job, :user => job.user}
    else
      render :text => "error"
    end
  end

  def update_rejected_job
    unless params[:deadline].blank?
      time = Time.strptime(params[:deadline], '%m/%d/%Y')
      params[:deadline] = time.strftime("%Y/%m/%d")
    end
    job = Job.find(params[:job_id])
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",params.inspect
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",params[:deadline]
     if job.update_attributes(:message_for => params[:job][:message_for],:pronounce_like => params[:job][:pronounce_like], :event_type_id => params[:job][:event_type_id],:deadline => params[:deadline],:is_gift => params[:job][:is_gift],:is_public => params[:job][:is_public],:message_details => params[:job][:message_details],:status => (job.status=="admin_rejected_job" || job.status=="celebrity_video_rejected") ? "pending"  : job.status)
       # event = EventType.find(params[:job][:event_type_id])
       # buffer = open("http://team.celebvidy.com//order-status?order_number=#{job.customer_job_id}&braintree_id=#{job.user.customer_id}&status=order_updated&type=#{event.name}&recipient=#{params[:job][:message_for]}&pronounced=#{params[:job][:pronounce_like]}&deadline=#{params[:deadline]}&instructions=#{params[:job][:message_details]}&gift=#{params[:job][:is_gift]}&public=#{params[:job][:is_public]}key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
       #   result = JSON.parse(buffer)
       #   puts "admin approved video????????????????????????????????????????",result
        # event_type = EventType.find(@job.event_type_id)
        # buffer = open("http://team.celebvidy.com/order-upsert?order_number=#{@job.customer_job_id}&order_id=#{@job.id}&braintree_id=#{@job.user.customer_id}&status=order_updated&amount=#{@celeb.celebrity.default_rate}&type=#{event_type.present? ? event_type.name : ""}&recipient=#{@job.message_for}&pronounced=#{@job.pronounce_like}&deadline=#{@job.deadline}&instructions=#{@job.message_details}&gift=#{@job.is_gift}&public=#{@job.is_public}&customer_name=#{@user.first_name}&customer_email=#{@user.email}&customer_state=#{@user.is_active}&customer_zipcode=#{@user.zip_code}&celebrity_id=#{@celeb.id}&celebrity_paybycheck=#{@celeb.payment_by_check}&customer_id=#{@user.id}&agent_code=""&celebrity_name=#{@celeb.full_name}&celebrity_start_date=""&braintreetree_customer_id=#{@user.customer_id}&braintree_created_at=#{@user.created_at}").read()
        #   result = JSON.parse(buffer)
        #   puts "Create Order????????????????????????????????????????",result

    render :text => job.inspect
     else
       render :text => "not"
       end
  end

  def billing_info
    user = User.find(params[:profile][:user_id])
    if user.braintree_info.present?
      result = Braintree::CreditCard.update(
          "#{user.braintree_info.payment_method_token}",
          :cvv => params[:cvv],
          :number => params[:credit_card_number].split(" ").join(""),
          :expiration_date => params[:date][:month]+ "/" + params[:date][:year],
          :cardholder_name => params[:holder_name],
          :options => {
              :verify_card => true,
              #:fail_on_duplicate_payment_method => true,
              :make_default => true
          }
      )
      if result.success?
        #puts "_________________________result.success?_________________________", result.inspect
        @braintree_info = user.braintree_info.update_attributes(:customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
        celeb = User.find(params[:celebId])
        job = user.jobs.last
        if user.profile.present?
          user.profile.update(profile_params)
        else
          profile = Profile.new(profile_params)
          profile.save
        end
        customer = Braintree::Customer.find("#{user.customer_id}")
        render :partial => 'confirm_order', :locals => {:user => user, :celeb => celeb, :job => job, :profile => (user.profile if user.profile.present?), :pay_info => customer.credit_cards.first}
      else
        #puts "_________________________result.error?_________________________", result.inspect
        render :json => {:success => 'false', :message => "#{result.errors.first.message}"}
      end
    else
      result = Braintree::CreditCard.create(
          :customer_id => user.customer_id,
          :cvv => params[:cvv],
          :number => params[:credit_card_number].split(" ").join(""),
          :expiration_date => params[:date][:month]+ "/" + params[:date][:year],
          :cardholder_name => params[:holder_name],
          :options => {
              :verify_card => true,
              #:fail_on_duplicate_payment_method => true,
              :make_default => true
          }
      )
      if result.success?
        #puts "_________________________result.success?_________________________", result.inspect
        @braintree_info = BraintreeInfo.create(:user_id => user.id, :customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
        celeb = User.find(params[:celebId])
        job = user.jobs.last
        if user.profile.present?
          user.profile.update(profile_params)
        else
          profile = Profile.new(profile_params)
          profile.save
        end
        customer = Braintree::Customer.find("#{user.customer_id}")
        render :partial => 'confirm_order', :locals => {:user => user, :celeb => celeb, :job => job, :profile => (user.profile if user.profile.present?), :pay_info => customer.credit_cards.first}
      else
        #puts "_________________________result.error?_________________________", result.inspect
        render :json => {:success => 'false', :message => "#{result.errors.first.message}"}
      end
    end

  end

  private

  def job_params
    params.require(:job).permit(:message_for, :pronounce_like, :is_gift,:is_public, :message_details, :deadline, :celebrity_id, :event_type_id, :status, :video_url, :delievery_date, :user_id)
  end

  def profile_params
    params.require(:profile).permit(:zip_code, :user_id)
  end

end

