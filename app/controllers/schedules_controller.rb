class SchedulesController < ApplicationController
  before_action :set_chedule, only: [:show, :edit, :update, :destroy]

  def index
    @chedules = Schedule.all
  end

  def show
  end

  def new
    @schedule = Schedule.new
  end

  def edit
  end

  def create
    @schedule = Schedule.build(set_date_info(schedule_params))
    respond_to do |format|
      if @schedule.save
        flash[:info] ='Schedule was successfully created.'
        format.html { redirect_to travel_path(@schedule.travel_date.travel) }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        flash[:info] ='Schedule was successfully updated.'
        format.html { redirect_to travel_path(@schedule.travel_date.travel) }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @schedule.destroy
    respond_to do |format|
      flash[:info] ='Schedule was successfully destroyed.'
      format.html { redirect_to travel_path(@schedule.travel_date.travel) }
      format.json { head :no_content }
    end
  end

  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:memo, :start_time, :end_time, :travel_date_id, :place_id)
    end

    def set_date_info(_params)
      travel_date = TravelDate.find(params[:schedule][:travel_date_id]).date
      _params['start_time(1i)'] = travel_date.year.to_s
      _params['start_time(2i)'] = travel_date.month.to_s
      _params['start_time(3i)'] = travel_date.day.to_s
      _params['end_time(1i)'] = travel_date.year.to_s
      _params['end_time(2i)'] = travel_date.month.to_s
      _params['end_time(3i)'] = travel_date.day.to_s

      _params
    end
end
