class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :update_memo, :destroy]

  def edit
    @travel = @schedule.travel_date.travel
  end

  def create
    @schedule = Schedule.build(schedule_params)
    if @schedule.save
      flash_msg = { info: 'スケジュールを作成しました' }
    else
      flash_msg = { danger: @schedule.errors.full_messages.join("\n") }
    end
    redirect_to travel_path(@schedule.travel_date.travel), change: 'schedule_list', flash_msg
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to travel_path(@schedule.travel_date.travel), change: 'schedule_list', info: 'スケジュールを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @schedule.destroy
    redirect_to travel_path(@schedule.travel_date.travel), info: 'スケジュールを削除しました'
  end

  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:memo, :start_time, :end_time, :travel_date_id, :place_id)
    end
end
