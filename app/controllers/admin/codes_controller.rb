class Admin::CodesController < ApplicationController
  layout "admin"

  def new
    @code = Code.new()
  end

  def create
  params[:number].to_i.times do
  @code = Code.new(:code_name => "CELEB" + rand(123456789).to_s)
  @code.save
  end
  redirect_to admin_codes_path

  end

  def index
    @codes = Code.all.where(:is_consumed => false)
  end

  def con_index
    @codes = Code.all.where(:is_consumed => true)
  end

  def destroy
    @code = Code.find(params[:id])
    if @code.destroy && @code.is_consumed == false
      redirect_to admin_codes_path
    elsif @code.destroy && @code.is_consumed == true
      redirect_to admin_codes_con_index_path
    end
  end


end
