class Admin::CelebritiesController < ApplicationController
  layout "admin"


  def new
    @user = User.new()
  end
  def create_celebrity
    puts "paramssssssssssssssssssssssssssssssssssss",params.inspect


    puts "paramssssssssssssssssssssssssssssssssssss",params.inspect
    puts "paramssssssssssssssssssssssssssssssssssss",params[:ssn]
    random_str = SecureRandom.hex
    @user = User.new(:email => params[:user][:email], :password => params[:user][:password],:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :user_type => params[:user][:user_type], :is_admin => false, :is_active => false, :is_deleted => false, :street_address => params[:street_address],:city => params[:city],:state => params[:state],:zip_code => params[:postal_code],:session_token => random_str)
    if create_merchant_on_braintree(@user, params[:account_number], params[:routing_number],params[:ssn])
      if @user.save
        @cel = Celebrity.new(celebrity_params)
        @cel.user_id = @user.id
      if @cel.save
         @address = PaymentAddress.create(:legal_name => params[:p_legal_name], :address => params[:p_address], :city => params[:p_city], :state => params[:p_state], :zip_code => params[:p_zip_code], :mail_to_name => params[:p_mail_to_name], :celebrity_id => @cel.id)
        if params[:charity_id].present?
        CelebrityCharities.create(:charity_percentage => "0",:celebrity_id => @cel.id, :charity_account_id => params[:charity_id])
        end
        flash[:success] = "Celebrity has been successfully created..."
        redirect_to "/admin/celebrities/all-celebrities"
      else
        flash[:danger] = @cel.errors.inspect
        render "/admin/celebrities/new"
      end
      #Celebrity.create(:user_id => @user.id, :about_me => params[:celebrity][:about_me], :description => params[:celebrity][:description], :default_rate => params[:celebrity][:default_rate],:per_alphabet_rate => params[:celebrity][:per_alphabet_rate],:verified_account => params[:celebrity][:verified_account],:avatar => params[:celebrity][:avatar],:date_of_birth => params[:celebrity][:date_of_birth],:fb_link=>params[:celebrity][:fb_link], :tw_link=>params[:celebrity][:tw_link], :pin_link=>params[:celebrity][:pin_link], :gmail_link=>params[:celebrity][:gmail_link], :in_link=>params[:celebrity][:in_link], :sn_link=>params[:celebrity][:sn_link])
      else
        flash[:notice] = "Error, User is not saved, Please create again... #{@user.errors.inspect}"
        redirect_to "/admin/celebrities/all-celebrities"
      end
    else
      #flash[:notice] = "Braintree Error, Some thing is wrong, Merchant is not created on Braintree..."
      render "/admin/celebrities/new", :locals => {:@industry_id => params[:celebrity][:industry_id],:@about_me => params[:celebrity][:about_me],:@charity_id => params[:charity_id],:@description => params[:celebrity][:description],:@default_rate => params[:celebrity][:default_rate],:@per_alphabet_rate => params[:celebrity][:per_alphabet_rate],:@avatar => params[:celebrity][:avatar],:@monthly_videos => params[:celebrity][:monthly_videos],:@default_delivery_days => params[:celebrity][:default_delivery_days],:@verified_account => params[:celebrity][:verified_account],:@street_address => params[:street_address],:@city => params[:city],:@state => params[:state],:@postal_code => params[:postal_code],:@ssn => params[:ssn],:@account_number => params[:account_number],:@routing_number => params[:routing_number],:@p_legal_name => params[:p_legal_name],:@p_address => params[:p_address],:@p_city => params[:p_city],:@p_state => params[:p_state],:@p_zip_code => params[:p_zip_code],:@p_mail_to_name => params[:p_mail_to_name]}
    end

    #@user = User.new(user_params)
    #if @user.save
    #  flash[:success] = "User has been created successfully"
    #  render :text => @user.id
    #else
    #  flash[:notice] = "Some fields are missing while creating user"
    #  puts "sssssssssss" , @user.errors
    #  render :text => "not"
    #end
  end

  def add_celebrity
    @user_id = params[:id]
  end

  #def add_celebrity_detail
  #  puts "00000000000000000",params.inspect
  #  aaaaaaaaaaaaaaaaaaaaaaaaaaa
  #  @cel = Celebrity.new(celebrity_params)
  #  if @cel.save
  #    if @cel.user.profile.nil?
  #      prof = Profile.new
  #    else
  #      prof = @cel.user.profile
  #    end
  #    if prof.update_attributes(:street_address => params[:street_address],
  #                              :city => params[:city],
  #                              :state => params[:state],
  #                              :zip_code => params[:postal_code],
  #                              :user_id => @cel.user_id)
  #      if create_merchant_on_braintree(@cel.user, prof, @cel.date_of_birth, params[:account_number], params[:routing_number])
  #        if @cel.user.update_attributes(:is_active => true)
  #          flash[:success] = "User has been created successfully"
  #          redirect_to "/admin/celebrities/all-celebrities"
  #        else
  #          flash[:notice] = "Some fields are missing while creating user as merchant"
  #          redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #        end
  #      else
  #        flash[:notice] = "Some fields are missing while creating user on braintree"
  #        redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #      end
  #    else
  #      flash[:notice] = "Some fields are missing while creating user profile"
  #      redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #    end
  #  else
  #    puts "0000000000000000000000000000", @cel.errors.inspect
  #    flash[:notice] = "Some fields are missing while creating user, #{@cel.errors.full_messages.to_sentence}"
  #    redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #  end
  #end

  def all_celebrities
    users = User.where(:user_type => "celebrity", :is_deleted => false)
    @active_users = users.where(:is_active => true)
    @inactive_users = users.where(:is_active => false)
  end


  def edit

    @user = User.find(params[:id])
    @celebrity = @user.celebrity
    if @user.merchant_id.present?
      @merchant_account = Braintree::MerchantAccount.find(@user.merchant_id) if @user.merchant_id.present?
      puts "////////////////////////////////////****************",@merchant_account.inspect
      puts "////////////////////////////////////****************",@merchant_account.individual_details.inspect
      puts "////////////////////////////////////****************",@merchant_account.business_details.inspect
    end

  end

  def show
   @user = User.find(params[:id])

  end


  def update_celebrity
    puts "00000000000000000000000000000000000000000000",params.inspect
    puts "00000000000000000000000000000000000000000000",params[:user]
    puts "00000000000000000000000000000000000000000000",params[:id]
    puts "00000000000000000000000000000000000000000000",params[:celebrity]
    puts "00000000000000000000000000000000000000000000",params[:account_number]
    puts "00000000000000000000000000000000000000000000",params[:routing_number]
    puts "00000000000000000000000000000000000000000000",params[:ssn]
    #puts "00000000000000000000000000000000000000000000",params.inspect
    @user = User.find(params[:id])
    @user.update_attributes(:email => params[:user][:email], :password => params[:user][:password],:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :user_type => params[:user][:user_type], :is_admin => false, :is_active => true, :is_deleted => false, :street_address => params[:street_address],:city => params[:city],:state => params[:state],:zip_code => params[:postal_code])
    if @user.merchant_id.present?
    if update_merchant_on_braintree(@user, params[:account_number], params[:routing_number],params[:ssn])
      if @user
#<ActiveModel::Errors:0x000000044b6460 @base=#<Celebrity id: nil, about_me: "123", description: "123", default_rate: 123.0, per_alphabet_rate: 123.0, verified_account: true, date_of_birth: "2015-05-18 00:00:00", fb_link: "www.facebook.com", tw_link: "www.facebook.com", pin_link: "www.facebook.com", gmail_link: "www.facebook.com", sn_link: "www.facebook.com", in_link: "www.facebook.com", user_id: nil, created_at: nil, updated_at: nil, avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, industry_id: 2, monthly_videos: 3, default_delivery_days: 3, additional_monthly_videos: nil, charity_rate: nil>, @messages={:avatar=>["can't be blank", "can't be blank"]}>
        @cel = @user.celebrity if @user.celebrity.present?
        if @user.celebrity.blank?
          @cel = Celebrity.new(celebrity_params)
          @cel.user_id = @user.id
        end
        if @cel.update_attributes(celebrity_params)
          if @cel.payment_address.present?
            @cel.payment_address.update_attributes(:legal_name => params[:p_legal_name], :address => params[:p_address],:city => params[:p_city], :state => params[:p_state],:zip_code => params[:p_zip_code],:mail_to_name => params[:p_mail_to_name])
          else
            PaymentAddress.create(:celebrity_id => @cel.id,:legal_name => params[:p_legal_name], :address => params[:p_address],:city => params[:p_city], :state => params[:p_state],:zip_code => params[:p_zip_code],:mail_to_name => params[:p_mail_to_name])
          end
          if params[:charity_id].present?
            cc = CelebrityCharities.where(:celebrity_id => @cel.id).first
            if cc.present?
            cc.update_attributes(:charity_account_id => params[:charity_id])
            else
            CelebrityCharities.create(:charity_percentage => "0",:celebrity_id => @cel.id, :charity_account_id => params[:charity_id])
              end
            end
          @cel.user_id = @user.id
          flash[:success] = "Celebrity has been successfully Updated..."
          redirect_to "/admin/celebrities/all-celebrities"
        else
          flash[:success] = @cel.errors.inspect
          redirect_to "/admin/celebrities/#{@user.id}/edit"
        end
        #Celebrity.create(:user_id => @user.id, :about_me => params[:celebrity][:about_me], :description => params[:celebrity][:description], :default_rate => params[:celebrity][:default_rate],:per_alphabet_rate => params[:celebrity][:per_alphabet_rate],:verified_account => params[:celebrity][:verified_account],:avatar => params[:celebrity][:avatar],:date_of_birth => params[:celebrity][:date_of_birth],:fb_link=>params[:celebrity][:fb_link], :tw_link=>params[:celebrity][:tw_link], :pin_link=>params[:celebrity][:pin_link], :gmail_link=>params[:celebrity][:gmail_link], :in_link=>params[:celebrity][:in_link], :sn_link=>params[:celebrity][:sn_link])
      else
        flash[:notice] = "Error, User is not saved, Please create again..."
        redirect_to "/admin/celebrities//#{@user.id}/edit"
      end
    else
      #flash[:notice] = "Braintree Error, Some thing is wrong, Merchant is not created on Braintree..."
      render "edit" , :locals => {:@celebrity => @cel,:@industry_id => params[:celebrity][:industry_id],:@about_me => params[:celebrity][:about_me],:@charity_id => params[:charity_id],:@description => params[:celebrity][:description],:@default_rate => params[:celebrity][:default_rate],:@per_alphabet_rate => params[:celebrity][:per_alphabet_rate],:@avatar => params[:celebrity][:avatar],:@monthly_videos => params[:celebrity][:monthly_videos],:@default_delivery_days => params[:celebrity][:default_delivery_days],:@verified_account => params[:celebrity][:verified_account],:@street_address => params[:street_address],:@city => params[:city],:@state => params[:state],:@postal_code => params[:postal_code],:@ssn => params[:ssn],:@account_number => params[:account_number],:@routing_number => params[:routing_number],:@p_legal_name => params[:p_legal_name],:@p_address => params[:p_address],:@p_city => params[:p_city],:@p_state => params[:p_state],:@p_zip_code => params[:p_zip_code],:@p_mail_to_name => params[:p_mail_to_name]}
    end
    else
      if create_merchant_on_braintree(@user, params[:account_number], params[:routing_number],params[:ssn])
        if @user.celebrity.present?
         if @user.celebrity.update_attributes(celebrity_params)
           flash[:success] = "Celebrity has been successfully Updated..."
           redirect_to "/admin/celebrities/all-celebrities"
         else
           flash[:success] = @cel.errors.inspect
           redirect_to "/admin/celebrities/new"
         end
        else
            @cel = Celebrity.new(celebrity_params)
            @cel.user_id = @user.id
            if @cel.save
              flash[:success] = "Celebrity has been successfully Updated..."
              redirect_to "/admin/celebrities/all-celebrities"
            else
              flash[:success] = @cel.errors.inspect
              redirect_to "/admin/celebrities/new"
            end

          end
          #Celebrity.create(:user_id => @user.id, :about_me => params[:celebrity][:about_me], :description => params[:celebrity][:description], :default_rate => params[:celebrity][:default_rate],:per_alphabet_rate => params[:celebrity][:per_alphabet_rate],:verified_account => params[:celebrity][:verified_account],:avatar => params[:celebrity][:avatar],:date_of_birth => params[:celebrity][:date_of_birth],:fb_link=>params[:celebrity][:fb_link], :tw_link=>params[:celebrity][:tw_link], :pin_link=>params[:celebrity][:pin_link], :gmail_link=>params[:celebrity][:gmail_link], :in_link=>params[:celebrity][:in_link], :sn_link=>params[:celebrity][:sn_link])
      else
        #flash[:notice] = "Braintree Error, Some thing is wrong, Merchant is not created on Braintree..."
        render "edit", :locals => {:@celebrity => @cel,:@industry_id => params[:celebrity][:industry_id],:@about_me => params[:celebrity][:about_me],:@charity_id => params[:charity_id],:@description => params[:celebrity][:description],:@default_rate => params[:celebrity][:default_rate],:@per_alphabet_rate => params[:celebrity][:per_alphabet_rate],:@avatar => params[:celebrity][:avatar],:@monthly_videos => params[:celebrity][:monthly_videos],:@default_delivery_days => params[:celebrity][:default_delivery_days],:@verified_account => params[:celebrity][:verified_account],:@street_address => params[:street_address],:@city => params[:city],:@state => params[:state],:@postal_code => params[:postal_code],:@ssn => params[:ssn],:@account_number => params[:account_number],:@routing_number => params[:routing_number],:@p_legal_name => params[:p_legal_name],:@p_address => params[:p_address],:@p_city => params[:p_city],:@p_state => params[:p_state],:@p_zip_code => params[:p_zip_code],:@p_mail_to_name => params[:p_mail_to_name]}
      end
    end


    #@user = User.find(params[:id])
    #if @user.update_attributes(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :password => params[:user][:password])
    #  flash[:success] = "User has been Updated successfully"
    #  render :text => @user.id
    #else
    #  flash[:notice] = "Some fields are missing while updating user"
    #  render :text => "not"
    #end

  end

  def get_celebrity_details
    @ceb = Celebrity.find_by_user_id(params[:id])
    # puts "000000000000000000000000000", @ceb.user.merchant_id.inspect
    if @ceb.present?
      merchant_account = Braintree::MerchantAccount.find(@ceb.user.merchant_id) if @ceb.user.merchant_id.present?
      if merchant_account.present?
        # puts "1111111111111111111111", merchant_account.inspect
      end
    else
      merchant_account = []
    end
    @user_id = (params[:id]).to_i
    if @ceb.nil?
      @ceb = Celebrity.create
    end
    render "update_celebrity", :locals => {:merchant_account => merchant_account}
  end

  #def update_celebrity_details
  #  puts "00000000000000000000000", params.inspect
  #  @cel = Celebrity.find_by_user_id(params[:celebrity][:user_id])
  #  if @cel == nil
  #    @cel = Celebrity.new(celebrity_params)
  #    if @cel.save
  #      #
  #      if @cel.user.profile.nil?
  #        prof = Profile.new
  #      else
  #        prof = @cel.user.profile
  #      end
  #      if prof.update_attributes(:street_address => params[:street_address],
  #                                :city => params[:city],
  #                                :state => params[:state],
  #                                :zip_code => params[:postal_code],
  #                                :user_id => @cel.user_id)
  #        if create_merchant_on_braintree(@cel.user, prof, @cel.date_of_birth, params[:account_number], params[:routing_number])
  #          if @cel.user.update_attributes(:is_active => true)
  #            flash[:success] = "User has been created successfully"
  #            redirect_to "/admin/celebrities/all-celebrities"
  #          else
  #            flash[:notice] = "Some fields are missing while creating user as merchant"
  #            redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #          end
  #        else
  #          flash[:notice] = "Some fields are missing while creating user on braintree"
  #          redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #        end
  #      else
  #        flash[:notice] = "Some fields are missing while creating user profile"
  #        redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #      end
  #      #
  #      #flash[:success] = "User has been created successfully"
  #      #redirect_to "/admin/celebrities/all-celebrities"
  #    else
  #      flash[:notice] = "Some fields are missing"
  #      redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #    end
  #  else
  #    if @cel.update_attributes(:about_me => params[:celebrity][:about_me], :description => params[:celebrity][:description], :default_rate => params[:celebrity][:default_rate], :per_alphabet_rate => params[:celebrity][:per_alphabet_rate], :verified_account => params[:celebrity][:verified_account], :fb_link => params[:celebrity][:fb_link], :tw_link => params[:celebrity][:tw_link], :gmail_link => params[:celebrity][:gmail_link], :pin_link => params[:celebrity][:pin_link], :in_link => params[:celebrity][:in_link], :sn_link => params[:celebrity][:sn_link])
  #      @cel.avatar = params[:celebrity][:avatar]
  #      @cel.save
  #
  #      #
  #      if @cel.user.profile.nil?
  #        prof = Profile.new
  #      else
  #        prof = @cel.user.profile
  #      end
  #      if prof.update_attributes(:street_address => params[:street_address],
  #                                :city => params[:city],
  #                                :state => params[:state],
  #                                :zip_code => params[:postal_code],
  #                                :user_id => @cel.user_id)
  #        if update_merchant_on_braintree(@cel.user, prof, @cel.date_of_birth, params[:account_number], params[:routing_number])
  #          if @cel.user.update_attributes(:is_active => true)
  #            flash[:success] = "User has been updated successfully"
  #            redirect_to "/admin/celebrities/all-celebrities"
  #          else
  #            flash[:notice] = "Some fields are missing while creating user as merchant"
  #            redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #          end
  #        else
  #          flash[:notice] = "Some fields are missing while creating user on braintree"
  #          redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #        end
  #      else
  #        flash[:notice] = "Some fields are missing while creating user profile"
  #        redirect_to "/admin/celebrities/add_celebrity?id=#{params[:celebrity][:user_id]}"
  #      end
  #      #
  #
  #      #flash[:success] = "User has been created successfully"
  #      #redirect_to "/admin/celebrities/all-celebrities"
  #    else
  #      flash[:notice] = "Some fields are missing while creating user"
  #      render :text => "not"
  #    end
  #  end
  #end

  def destroy
    @user = User.find(params[:id])
    @cel = Celebrity.find_by_user_id(@user.id)
    if @ceb.present?
      @cel.destroy
    end
    if @user.destroy
      @code = Code.where(:device_token => @user.device_token)
      unless @code.blank?
      @code.each do |code|
        code.destroy
      end
      end
      redirect_to :controller => "admin/celebrities", :action => "all-celebrities"
      flash[:notice] = "User has been deleted successfully."
    else
      redirect_to :controller => "admin/celebrities", :action => "all-celebrities"
    end
  end

  def active_deactive_celebrity
    @user = User.find(params[:id])
    if @user.is_active == false
      @user.update_attributes(:is_active => true)
      flash[:notice] = "Celebrity Successfully Activated"
      render :text => "deactive"
    else
      @user.update_attributes(:is_active => false)
      flash[:notice] = "Celebrity Successfully Deactivated"
      render :text => "active"
    end
  end

  def approve_introduction_video_by_admin
    @cel = Celebrity.find(params[:id])
    if @cel.update_attributes(:is_video_verified => true)
      render :text => "ok"
    else
      render :text => "notok"
    end
  end

  def reject_introduction_video_by_admin
    @cel = Celebrity.find(params[:id])
    if @cel.update_attributes(:is_video_verified => false)
      @cel.update_attributes(:video_url => "")
      render :text => "ok"
    else
      render :text => "notok"
    end
  end



  private
  def user_params
    params.require(:user).permit(:first_name, :email, :password, :password_confirmation, :last_name, :is_active, :user_type, :is_admin, :is_active, :is_deleted, :street_address,:city,:state,:zip_code,:celebrity_attributes => [:first_name, :last_name, :age, :gender, :post_code, :url, :address_line1, :id, :country, :city, :street_address, :state]) #, :profile_attributes => [:about_yourself, :gender, :phone_number,:distance])
  end

  def celebrity_params
    params.require(:celebrity).permit(:about_me,:industry_id, :description, :default_rate, :per_alphabet_rate, :date_of_birth, :verified_account,:avatar, :fb_link, :tw_link, :gmail_link, :pin_link, :in_link, :sn_link, :monthly_videos, :default_delivery_days)
  end

end
