class EventsController < ApplicationController
  before_action :set_event , only: [:show, :edit, :update, :destroy]
  before_action :set_places, only: [:new, :edit, :create, :update]

  def index
    @events = current_user.events.order(start_date: :desc).page(params[:page])
  end

  def show
    @need_pages_js = true
    @places_for_map  = [{ name: @event.place.name, latitude: @event.place.latitude, longitude: @event.place.longitude }].to_json
    @map_zoom = 12
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.build(event_params, current_user)
    if @event.save
      redirect_to events_url, info: %("#{@event.name}"を登録しました)
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to events_url, info: %("#{@event.name}"の情報を更新しました)
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, info: %("#{@event.name}"を削除しました)
  end

  private
    def set_event
      @event = current_user.events.find(params[:id])
    end

    def set_places
      @places = current_user.places.not_gone.order(updated_at: :desc).pluck(:name, :id)
    end

    def event_params
      params.require(:event).permit(:name, :detail, :start_date, :end_date, :place_id)
    end
end
