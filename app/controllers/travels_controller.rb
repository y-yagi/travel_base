class TravelsController < ApplicationController
  before_action :set_travel, only: [:edit, :update, :destroy, :edit_photo]

  def index
    @travels = Travel.all
  end

  def show
    @places = Place.mine(current_user).pluck(:name, :id)
    @travel = Travel.schedules.mine(current_user).find(params[:id])
  end

  def new
    @travel = Travel.new
  end

  def edit
  end

  def create
    @travel = Travel.build(travel_params, current_user)

    if @travel.save
      flash[:info] ='旅行情報を作成しました'
      redirect_to @travel
    else
      render :new
    end
  end

  def update
    if @travel.update(travel_params)
      flash[:info] ='旅行情報を更新しました'
      redirect_to @travel
    else
      render :edit
    end
  end

  def destroy
    @travel.destroy
    flash[:info] ='旅行情報を削除しました'
    redirect_to travels_url
  end

  private
    def set_travel
      @travel = Travel.mine(current_user).find(params[:id])
    end

    def travel_params
      params.require(:travel).permit(:name, :memo, :start_date, :end_date, :deleted_at, :user_id)
    end
end
