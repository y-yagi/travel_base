class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :update_memo, :destroy]

  def new
    @schedule = Schedule.new
  end

  def edit
  end

  def create
    @schedule = Schedule.build(schedule_params)
    if @schedule.save
      flash[:info] ='Schedule was successfully created.'
      redirect_to travel_path(@schedule.travel_date.travel)
    else
      render :new
    end
  end

  def update
    if @schedule.update(schedule_params)
      flash[:info] ='Schedule was successfully updated.'
      redirect_to travel_path(@schedule.travel_date.travel)
    else
      render :edit
    end
  end

  def update_memo
    @schedule.update!(memo: params[:value])
    head :ok
  end

  def destroy
    @schedule.destroy
    flash[:info] ='Schedule was successfully destroyed.'
    redirect_to travel_path(@schedule.travel_date.travel)
  end

  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:memo, :start_time, :end_time, :travel_date_id, :place_id)
    end
end
