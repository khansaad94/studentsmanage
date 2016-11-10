class Admin::EventTypesController < ApplicationController

  layout "admin"

  def index
    @event_types = EventType.all
  end

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(event_type_params)
    if @event_type.save
      flash[:notice] = "Event type was successfully added."
      render :json => {:success => true, :url => admin_event_types_path}.to_json
    else
      @errors = @event_type.errors
      render :json => {:success => false, :html => render_to_string(:partial => '/layouts/errors')}.to_json
    end
  end

  def update
    @event_type = EventType.find_by_id(params[:event_type][:id])
    if @event_type.update_attributes(:name => params[:event_type][:name])
      flash[:notice] = "Event Type was successfully added."
      redirect_to admin_event_types_path
      # render :json => {:success => true, :url => edit_admin_event_types_path}.to_json
    else
      @errors = @event_type.errors
      render :json => {:success => false, :html => render_to_string(:partial => '/layouts/errors')}.to_json
    end
  end

  def edit
    @event_type = EventType.find_by_id(params[:id])
  end

  def destroy
    @e_type = EventType.find(params[:id])
    @e_type.destroy

    redirect_to admin_event_types_path
  end

  def event_type_params
    params.require(:event_type).permit(:name)
  end

end
