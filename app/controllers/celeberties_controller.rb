class CelebertiesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  #before_filter :authenticate_user, :only => [:my_account]
  require "open-uri"
  def index
    @celebs = User.all_non_deleted_celebrities
    @celebs = @celebs.order('first_name ASC')
  end

  def show
    @celeb = User.find_celeb(params[:id])
  end

  def ping_to_server
  begin
  puts "000000000000000000000000000000000000000000000000",params.inspect
  job = Job.find(params[:jid])
  buffer = open("http://team.faceyspacey.com/order-email?order_number='#{job.customer_job_id if job.present?}'&braintree_id='#{current_user.customer_id if current_user.present?}'&email='#{params[:email]}'&key=52ababf575104083826c8ca404f7278500d59aba").read()
  result = JSON.parse(buffer)
  render :text => "ok"
  rescue
    render :text => "notok"
  end
  end

  def pending_status

  end
  def order_updated
  end


  def search_celeberty
    @celebs = User.all_non_deleted_celebrities
    @verified = @celebs.limit(7) if @celebs.present? #Celebrity.where(:verified_account => true).limit(7)
    @celebs = @celebs.order('first_name ASC')
    #render :partial => 'search_celeberty', :locals => {:celebs => @celebs.order('first_name ASC'), :verified => @verified}
  end

  def search_celebrities
    @celebs = User.all_non_deleted_celebrities
    @verified = @celebs.limit(7) if @celebs.present? #Celebrity.where(:verified_account => true).limit(7)
    @celebs = @celebs.order('first_name ASC')
    #render :partial => 'search_celeberty', :locals => {:celebs => celebs.order('first_name ASC'), :verified => verified}
  end


  def searching
    #if params[:ind]==''
      celebs = User.search_celeb_by_name(params[:text])
    #else
    #  celebs = User.search_celeb_by_name_and_industry(params[:text], params[:ind])
    #end
    if (params[:search]=="directory")
      render :partial => 'celebs_directory', :locals => {:celebs => celebs.order('first_name ASC')}
    else
      render :partial => 'all_celebs', :locals => {:celebs => celebs.order('first_name ASC')}
    end
  end

  def searching_from_index
    @celebs = User.search_celeb_by_name(params[:text])
    @all_celebs = User.all_non_deleted_celebrities
    @verified = @all_celebs.limit(7)  if @all_celebs.present?
    render :partial => 'search_celeberty', :locals => {:celebs => @celebs.order('first_name ASC'), :verified => @verified, :@text => params[:text]}
  end

  def order_success
    @user = User.find(params[:uid])
    @celeb = User.find(params[:cid])
    @job = Job.find(params[:jid])
    @event = EventType.find(@job.event_type_id)
    @profile = current_user.profile if current_user.profile.present?
    customer = Braintree::Customer.find("#{@user.customer_id}")
    @pay_info = customer.credit_cards.first
    if @job.status == "incomplete"
      result = Braintree::Transaction.sale(
          :customer_id => @user.customer_id,
          :amount => "#{@celeb.celebrity.default_rate}",
          :payment_method_token => @user.braintree_info.payment_method_token,
          #.................................
          :custom_fields => {
              agentcode: "0",
               customerkey: @user.customer_id,
               celebritykey: @celeb.merchant_id,
               customername: @user.first_name.present? ? @user.first_name : "no name provided",
               celebrityname: @celeb.full_name.present? ? @celeb.full_name : "no name provided",
               recipient: @job.message_for,
               pronounced: @job.pronounce_like,
               deadline: @job.deadline,
               instructions: @job.message_details,
               public: @job.is_public,
               type: @event.present? ? @event.name : ""
          },
          #.................................
          :options => {
              :submit_for_settlement => true
          }
      )
      if result.success?
        @history = TransactionHistory.create(:transaction_id => result.transaction.id, :transaction_type => result.transaction.type, :status => result.transaction.status, :transaction_amount => result.transaction.amount, :merchant_id => "", :customer_id => @user.customer_id, :user_id => @user.id, :job_id => @job.id)
        @job.update_attributes(:status => ApplicationHelper::JOBS_STATUS[1])
        ContactMailer.send_email_on_payment_success(@user,@celeb,@job).deliver
        # event_type = EventType.find(@job.event_type_id)
        # buffer = open("http://team.celebvidy.com/order-upsert?order_number=#{@job.customer_job_id}&order_id=#{@job.id}&braintree_id=#{@job.user.customer_id}&status=order_submitted&amount=#{@celeb.celebrity.default_rate}&type=#{event_type.present? ? event_type.name : ""}&recipient=#{@job.message_for}&pronounced=#{@job.pronounce_like}&deadline=#{@job.deadline}&instructions=#{@job.message_details}&gift=#{@job.is_gift}&public=#{@job.is_public}&customer_name=#{@user.first_name}&customer_email=#{@user.email}&customer_state=#{@user.is_active}&customer_zipcode=#{@user.zip_code}&celebrity_id=#{@celeb.id}&celebrity_paybycheck=#{@celeb.payment_by_check}&customer_id=#{@user.id}&agent_code=""&celebrity_name=#{@celeb.full_name}&celebrity_start_date=""&braintreetree_customer_id=#{@user.customer_id}&braintree_created_at=#{@user.created_at}").read()
        #   result = JSON.parse(buffer)
        #   puts "Create Order????????????????????????????????????????",result
      else
        render :json => {:success => 'false', :message => "#{result.inspect}"}
      end
    end
  end



  def fqs
  end


  def user_account
    user = User.find(params[:user_id])
    jobs = user.jobs.order("created_at DESC")
    render :partial => 'my_account', :locals => {:@user => user, :@jobs => jobs}
  end

  def edit_pass
    user = User.find(params[:id])
    render :partial => 'edit_password', :locals => {:@user => user}
  end

  def update_pass
    user = User.find(params[:user_id])
    if user.valid_password?(params[:old_password])
      user.update_attributes(:password => params[:new_password])
      jobs = user.jobs
      sign_in user, :bypass => true
      render :text => "ok"
      #render :partial => 'my_account', :locals => {:user => user, :jobs => jobs}
    else
      render :json => {:success => 'false', :message => "you typed your old password wrong"}
    end
  end

  def static_pages
    if params[:page] == "about"
      render :partial => 'about'
    elsif params[:page] == "faqs"
      render :partial => 'faqs'
    elsif params[:page] == "terms"
      render :partial => 'terms'
    elsif params[:page] == "our_team"
      render :partial => 'our_team'
    elsif params[:page] == "contact_us"
      render :partial => 'contact_us'
    elsif params[:page] == "privacy_policy"
      render :partial => 'privacy_policy'
    elsif params[:page] == "how_it_work"
      render :partial => 'how_it_work'
    end
  end
  def  celebrity_video

  end

  def  pending_status

  end

  def get_video
    user = User.find(params[:cid])
    job = Job.find(params[:jid])
    render :partial => 'celebrity_video', :locals => {:user => user, :job => job}
  end

  def pending_status
    celeb = User.find_celeb(params[:cid])
    job = Job.find(params[:jid])
    user = job.user
    render :partial => 'pending_status', :locals => {:@celeb => celeb, :job => job, :user => user}
  end


  def check_email
    @user = User.where(:email => params[:user][:email]).first
    render :text => "true" if @user.blank?
    render :text => "false" if @user.present?
  end

  def privacy_policy
  end

  def terms_of_services
  end

  def my_account
    @user = current_user
    @jobs = @user.jobs.order("created_at DESC")
    #render :partial => 'my_account', :locals => {:user => user, :jobs => jobs}
  end


  def cart
    if current_user.present?
      jobs = current_user.jobs.where(:status => 'incomplete')
      jobs = jobs.order("created_at DESC")
      render :partial => 'cart', :locals => {:jobs => jobs}
    else
      render :json => {:success => 'false', :message => "/users/sign_up"}
    end

  end

  def contact_mail
    mailer = ContactMailerInformation.new(:first_name => params[:first_name],:last_name => params[:last_name], :email => params[:email],:phone_number =>  params[:phone_number], :order_number => params[:order_number], :site_issue => params[:bug_type], :description => params[:q_c])
    if mailer.save
    if ContactMailer.contact_email((params[:first_name] + ' ' + params[:last_name]), params[:email], params[:phone_number], params[:order_number], params[:bug_type], params[:q_c]).deliver
      # user = User.where(:email => params[:email]).first
      # buffer = open("http://team.celebvidy.com/support-message?order_number=#{params[:order_number]}&braintree_id=#{user.present? ? user.customer_id : ""}&email=#{user.present? ? user.email : params[:email]}&subject=#{params[:bug_type]}&message=#{params[:q_c]}&customer_id=#{user.present? ? user.id : ""}&customer_name=#{params[:first_name]}").read()
      # puts "///////////////////////////////////////////////////////",buffer.inspect
      #   result = JSON.parse(buffer)
      #   puts "Support Message????????????????????????????????????????",result
    end
      redirect_to '/thank-notes'
    else
      redirect_to '/'
    end
  end

  def check_order
    @job = Job.where(:customer_job_id => params[:order_number]).first
    render :text => "false" if @job.blank?
    render :text => "true" if @job.present?
  end

end
