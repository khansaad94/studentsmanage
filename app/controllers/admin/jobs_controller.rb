class Admin::JobsController < ApplicationController

  include ApplicationHelper
  layout "admin"

  def index
    @pending_jobs = Job.includes(:user, :event_type).where(:status => "pending")
    @admin_approved_job = Job.includes(:user, :event_type).where(:status => "admin_approved_job")
    puts "00000000000000000000000000000",@admin_approved_job.inspect
    @completed_jobs = Job.includes(:user, :event_type).where(:status => "completed")
    @rejected_jobs = Job.includes(:user, :event_type).where(:status => "admin_rejected_job")
  end

  def upload_video
    @job = Job.find(params[:id])
  end

  def update
    id = params[:id].to_i
    @job = Job.find(id)
    if @job.update(job_params)
      @job.update_attributes(:status => ApplicationHelper::JOBS_STATUS[0])
      redirect_to action: "completed_job"
    else
      redirect_to action: "upload_video"
    end
  end

  def completed_job
    @job = Job.find(params[:id])
    end

  def job_details
    @job = Job.find(params[:id])
  end

  def approve_job_by_admin
    @job = Job.find(params[:id])
    if @job.update_attributes(:status => "admin_approved_job")
      if @job.user.present?
        @user = User.find(@job.celebrity_id)
        message = "#{@job.user.present? ? @job.user.full_name : ""} requested a video from you."
        if @user.present? && @user.push_notification == true
        send_push_notification_to_celebrity(@user, message)
        end
      end
          buffer = open("http://team.celebvidy.com/order-status?order_number=#{@job.customer_job_id}&braintree_id=#{@job.user.customer_id}&status=order_approved&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
            result = JSON.parse(buffer)
            puts "admin approved ORDER????????????????????????????????????????",result
      flash[:success] = "Job has been successfully approved..."
      render :text => "ok"
    else
      flash[:notice] = "Some error occured, try again to approve this job..."
      render :text => "notok"
    end
  end


  def reject_job_by_admin
    @job = Job.find(params[:id])
    if @job.update_attributes(:status => "admin_rejected_job")
      puts  "000000000000000000000000000000000000",@job.user.email
      puts  "000000000000000000000000000000000000",User.find(@job.celebrity_id)
      puts  "000000000000000000000000000000000000",@job
      cel_user = User.find(@job.celebrity_id)
      ContactMailer.video_rejected_email(@job.user,cel_user,@job).deliver
      if @job.user.present?
       @user = User.find(@job.celebrity_id)
       message = "#{@user.full_name} Rejected your offer..."
       send_push_notification_to_user(@job.user, message)
      end
      #
          buffer = open("http://team.celebvidy.com/order-status?order_number=#{@job.customer_job_id}&braintree_id=#{@job.user.customer_id}&status=order_rejected&reason=admin&message=optional&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
          # buffer = open("http://team.celebvidy.com/order-status?order_number=#{@job.customer_job_id}&braintree_id=#{@job.user.customer_id}&status=order_approved&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
            result = JSON.parse(buffer)
            puts "admin rejected ORDER????????????????????????????????????????",result
      flash[:success] = "Job has been rejected..."
      render :text => "ok"
    else
      flash[:notice] = "Some error occured, try again to reject this job..."
      render :text => "notok"
    end
  end

  def approve_video_by_admin
    @job = Job.find(params[:id])
    if @job.update_attributes(:status => "completed")
      cel_user = User.find(@job.celebrity_id)
      ContactMailer.video_accepted_email(@job.user,cel_user,@job).deliver
      if @job.user.present?
       @user = User.find(@job.celebrity_id)
       message = "#{@user.present? ? @user.full_name : ""} Accepted your offer, Your video is ready..."
       send_push_notification_to_user(@job.user, message)
      end
      buffer = open("http://team.celebvidy.com/order-status?order_number=#{@job.customer_job_id}&braintree_id=#{@job.user.customer_id}&status=video_delivered&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
      # buffer = open("http://team.celebvidy.com/order-status?order_number=#{@job.customer_job_id}&braintree_id=#{@job.user.customer_id}&status=order_approved&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
        result = JSON.parse(buffer)
        puts "admin approved video????????????????????????????????????????",result
      flash[:success] = "video has been successfully approved..."
      render :text => "ok"
    else
      flash[:notice] = "Some error, video has not been approved..."
      render :text => "notok"
    end
  end


  def reject_video_by_admin
    @job = Job.find(params[:id])
    if @job.update_attributes(:status => "admin_approved_job")
      #if @job.user.present?
      #  @user = User.find(@job.celebrity_id)
      #  message = "#{@user.present? ? @user.full_name : ""} Rejected your offer..."
      #  send_push_notification_to_user(@job.user, message)
      #end
      buffer = open("http://team.celebvidy.com/order-status?order_number=#{@job.customer_job_id}&braintree_id=#{@job.user.customer_id}&status=video_rejected&reason=no&message=optionalmessage&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
      # buffer = open("http://team.celebvidy.com/order-status?order_number=#{@job.customer_job_id}&braintree_id=#{@job.user.customer_id}&status=order_approved&key=492b125dbaff82d54ff0286c64980bff6465ce60").read()
        result = JSON.parse(buffer)
        puts "admin approved video????????????????????????????????????????",result
      flash[:success] = "video has been rejected..."
      render :text => "ok"
    else
      flash[:success] = "some errorr, Job has not been rejected..."
      render :text => "notok"
    end
  end

  def celebrity_completed_jobs
    @celebrity_completed_jobs = Job.includes(:user, :event_type).where(:status => "celebrity_video_completed")
  end

  def deadline_missed_jobs
    @deadline_missed_jobs = Job.includes(:user, :event_type).where('status != ? AND deadline < ?', 'completed', Time.now)
  end

  #def show
  #  @media_item = MediaItem.find(params[:id])
  #end
  #
  #def new
  #  @media_item = MediaItem.new
  #end
  #
  #def edit
  #  @media_item = MediaItem.find(params[:id])
  #end
  #
  #def create
  #  @media_item = MediaItem.new(media_item_params)
  #
  #  if @media_item.save
  #    redirect_to @media_item
  #  else
  #    render 'new'
  #  end
  #end
  #
  #def update
  #  @media_item = MediaItem.find(params[:id])
  #
  #  if @media_item.update(media_item_params)
  #    redirect_to @media_item
  #  else
  #    render 'edit'
  #  end
  #end
  #
  #def destroy
  #  @media_item = MediaItem.find(params[:id])
  #  @media_item.destroy
  #
  #  redirect_to media_items_path
  #end
  #
  #private
  def job_params
    params.require(:job).permit(:video)
  end

end
