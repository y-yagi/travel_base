class RoutesController < ApplicationController
  before_action :set_route, only: [:edit, :update, :destroy]
  before_action :set_schedule

  def new
    @route = @schedule.build_route
  end

  def edit
  end

  def create
    @route = @schedule.build_route(route_params)
    if @route.save
      redirect_to travel_path(@schedule.travel_date.travel), info: '移動方法を作成しました'
    else
      render :new
    end
  end

  def update
    if @route.update(route_params)
      redirect_to travel_path(@schedule.travel_date.travel), info: '移動方法を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @route.destroy
    redirect_to travel_path(@schedule.travel_date.travel), info: '移動方法を削除しました'
  end

  private
    def set_route
      @route = Route.find(params[:id])
    end

    def route_params
      params.require(:route).permit(:detail)
    end

    def set_schedule
      @schedule = Schedule.find(params[:schedule_id])
    end
end
