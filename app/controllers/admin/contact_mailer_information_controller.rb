class Admin::ContactMailerInformationController < ApplicationController
  layout "admin"

  def index
    contact_mailer = ContactMailerInformation.all.order("created_at DESC")
    @contact_mailer = contact_mailer.order("created_at DESC")
  end

  def show
    @contact_mailer = ContactMailerInformation.find(params[:id])
  end

  def reply_email
    @contact_mailer = ContactMailerInformation.find(params[:contact_id])
    if params[:reply_message].present?
    if ContactMailer.send_email_on_contact_reply(@contact_mailer,params[:reply_message]).deliver
    flash[:success] = "Email has been sent successfully."
    redirect_to admin_contact_mailer_information_index_path
    else
      flash[:notice] = "Due To Error, Email Not Sent, Please Try Again."
      redirect_to "/admin/contact_mailer_information/#{params[:contact_id]}"
    end
    else
      flash[:notice] = "Reply text is required to send email"
      redirect_to "/admin/contact_mailer_information/#{params[:contact_id]}"
    end
  end


end
