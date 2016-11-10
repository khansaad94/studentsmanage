class Users::PasswordsController < Devise::PasswordsController
  append_before_filter :assert_reset_token_passed, :only => :del, :except => :edit
  # before_action :edit_pass, :only => :edit
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    #User.where(:email => params[:fname]).first.send_reset_password_instructions
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit

    puts "////////////////////////////////////////",params.inspect
    # self.resource = resource_class.new
    # p "aaaaaaaaaaaaaaaaaaaaaaa", self.resource
    puts "AAAAAAAAAAAAAAAAAAA///////////////////////",User.where(:reset_password_token => params[:reset_password_token]).first
    puts "AAAAAAAAAAAAAAAAAAA///////////////////////",@resource
    if request.env['HTTP_USER_AGENT'].downcase.match(/iphone/) != nil
      redirect_to "celebrityappf://www?reset_token=#{params[:reset_password_token]}" and return
    end
    super
  # set_minimum_password_length
  # resource.reset_password_token = params[:reset_password_token]
  end


  # PUT /resource/password
  def update
   p "dshjshdfjdhsfjhdsjfkh", params
    super
  end

  # protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end

  # def edit_pass
  # @resource = User.find(params[:id]) if params[:id].present?
  # @token = params[:token] if params[:token].present?
  # if request.env['HTTP_USER_AGENT'].downcase.match(/iphone/) != nil
  # url = edit_password_url(@resource, :reset_password_token => @token)
  # url.slice!('http://')
  # redirect_to 'Adoorn://' + url
  # else
  # redirect_to edit_password_url(@resource, :reset_password_token => @token)
  # end
  # end
end
