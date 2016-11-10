class Admin::CharityAccountsController < ApplicationController

  layout "admin"
  require 'date'

  def index
    @c_accounts = CharityAccount.all
  end

  def new
    @c_account = CharityAccount.new
  end

  def create

    #d_o_b = Date.new(params[:dob][:year].to_i, params[:dob][:month].to_i, params[:dob][:day].to_i)
    result = Braintree::MerchantAccount.create(
        :individual => {
            :first_name => params[:name],
            :last_name => params[:name],
            :email => params[:email],
            :date_of_birth => "2014-01-01",
            :address => {
                :street_address => params[:street_address],
                :locality => params[:city],
                :region => params[:state],
                :postal_code => params[:postal_code]
            }
        },
        :funding => {
            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
            :account_number => params[:account_number],
            :routing_number => params[:routing_number]
        },
        :tos_accepted => true,
        :master_merchant_account_id => "ycdtqqj2qjby6wgt"
    )
    # puts " sssssssssssssssssssssss ", result.inspect
    if result.success?
      @c_account = CharityAccount.new(:name => params[:name])
      @c_account.merchant_id = result.merchant_account.id
      if @c_account.save!
        flash[:success] = "Charity Account has been successfully created..."
        redirect_to "/admin/charity_accounts"
      else
        @c_account.destroy
        # puts "error ", result.inspect
        flash[:notice] = "Problem saving charity account." + @c_account.errors.inspect
        redirect_to "/admin/charity_accounts/new"
      end
    else
      puts "00000000000000000000000000",params.inspect
      flash[:notice] = "Problem saving charity account." + result.message
      #redirect_to "/admin/charity_accounts/new"
      # render :json => {:success => false, :html => render_to_string(:partial => '/layouts/errors')}.to_json

      render "/admin/charity_accounts/new", :locals => {:@name => params[:name], :@email => params[:email], :street_address => params[:street_address], :city => params[:city], :state => params[:state], :postal_code => params[:postal_code],:account_number => params[:account_number], :routing_number => params[:routing_number]}
    end

  end

  def update
    puts "0000000000000000000000000000",params.inspect
    @c_account = CharityAccount.find(params[:id])
    #d_o_b = Date.new(params[:dob][:year].to_i, params[:dob][:month].to_i, params[:dob][:day].to_i)
    puts "0000000000000000000000000000",@c_account.inspect
    puts "0000000000000000000000000000",@c_account.merchant_id.inspect

    result = Braintree::MerchantAccount.update(
        @c_account.merchant_id,
        :individual => {
            :first_name => params[:name],
            :last_name => params[:name],
            :email => params[:email],
            :date_of_birth => "2014-01-01",
            :address => {
                :street_address => params[:street_address],
                :locality => params[:city],
                :region => params[:state],
                :postal_code => params[:postal_code]
            }
        },
        :funding => {
            :destination => Braintree::MerchantAccount::FundingDestination::Bank,
            :account_number => params[:account_number],
            :routing_number => params[:routing_number]
        },
        #:tos_accepted => true,
        #:master_merchant_account_id => "ycdtqqj2qjby6wgt"
    )
    # puts " sssssssssssssssssssssss ", result.inspect
    if result.success?
      if @c_account.update_attributes(:merchant_id => result.merchant_account.id, :name => params[:name])
        flash[:success] = "Charity Account has been successfully Updated..."
        redirect_to "/admin/charity_accounts"
      else
        # puts "error ", result.inspect
        flash[:notice] = "Problem Updating Local Database charity account name." + @c_account.errors.inspect
        redirect_to "/admin/charity_accounts/#{@c_account.id}/edit"
      end
    else
      flash[:notice] = "Problem saving charity account." + result.message
      redirect_to "/admin/charity_accounts/#{@c_account.id}/edit"
      # render :json => {:success => false, :html => render_to_string(:partial => '/layouts/errors')}.to_json
    end

    #if @c_account.update_attributes(:name => params[:charity_account][:name])
    #  flash[:notice] = "Charity account is successfully added."
    #  redirect_to admin_charity_accounts_path
    #else
    #  @errors = @c_account.errors
    #  render :json => {:success => false, :html => render_to_string(:partial => '/layouts/errors')}.to_json
    #end
  end

  def edit
    @c_account = CharityAccount.find_by_id(params[:id])
    if @c_account.merchant_id.present?
      @merchant_account = Braintree::MerchantAccount.find(@c_account.merchant_id) if @c_account.merchant_id.present?
    end
    puts "00000000000000000000000000000000000",@merchant_account.inspect


  end

  def destroy
    @c_account = CharityAccount.find(params[:id])
    @c_account.destroy

    redirect_to admin_charity_accounts_path
  end

  def payment_index
    @cel_cc = CelebrityCharities.all
  end

  def new_payment
    @c_account = CelebrityCharities.new()
    cel_char = CelebrityCharities.all.map(&:celebrity_id)
    unless cel_char.blank?
      @celebrities = Celebrity.where('id not in (?)', cel_char)
    else
      @celebrities = Celebrity.all
    end
    user_ids = @celebrities.all.map(&:user_id)
    users = User.where('id in (?)', user_ids)
    @celb = []
    users.each do |user|
      cel = @celebrities.find_by_user_id(user.id)
      @celb.push([user.first_name , cel.id])
    end

  end

  def celebrity_charity_accounts
    # puts "params ;;;;;;;;;;;", params.inspect
    @c_acc = CelebrityCharities.new(celebrity_charities_params)
    if @c_acc.save!
      flash[:notice] = "Celebrity Charity account is successfully added."# + @c_acc.errors.inspect
      redirect_to "/admin/charity_accounts/payment-index"
    else
      @errors = @c_acc.errors
      render :json => {:success => false, :html => render_to_string(:partial => '/layouts/errors')}.to_json
    end

  end


  #def charity_account_params
  #  params.require(:charity_account).permit(:name)
  #end

  def celebrity_charities_params
    params.require(:celebrity_charities).permit(:celebrity_id, :charity_percentage, :charity_account_id)
  end

end
