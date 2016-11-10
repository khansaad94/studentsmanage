class ContactMailer < ActionMailer::Base
  #default :from => "CelebVidy <celebvidyapp@gmail.com>"
  default :from => "noreply@celebvidy.com"

  def contact_email(name, email, phone_no, order_no, bug_type, body)
    @name = name
    @email = email
    @p_no = phone_no
    @o_no = order_no
    @b_type = bug_type
    @message = body
    mail(:to => "noreply@celebvidy.com", :subject => 'Contact Email')
    #mail(:to => " admin@celebvidy.com ", :subject => 'Contact Email', :name => @name, :email => @email, :phone_no => @p_no, :order_no => @o_no, :bug => @b_tupe, :message => @message)
  end



  def send_email_on_payment_success(user,celebrity_user,job)
    @user = user
    @celebrity_user = celebrity_user
    @job = job
    mail(to: @user.email, subject: '[Celebvidy] Order Confirmation')
  end

  def send_email_on_contact_reply(contact_mailer,message)
    @contact_mailer = contact_mailer
    @reply_message = message
    mail(to: @contact_mailer.email, subject: '[Celebvidy] Email')
  end

  def video_accepted_email(job_user,celebrity_user,job)
    @user = job_user
    @celebrity_user = celebrity_user
    @job = job
    mail(to: @user.email, subject: '[Celebvidy] Order Accepted')
  end

  def video_rejected_email(job_user,celebrity_user,job)
    @user = job_user
    @celebrity_user = celebrity_user
    @job = job
    mail(to: @user.email, subject: '[Celebvidy] Order Rejected')
  end



end
