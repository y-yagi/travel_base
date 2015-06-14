class TravelsController < ApplicationController
  before_action :set_travel, only: [:edit_photo]
  before_action :set_travel_by_owner, only: [:edit, :update, :destroy]
  before_action :set_page_js, only: [:new, :show, :edit, :update]

  def index
    @travels = Travel.belong(current_user).order('start_date DESC').page(params[:page])
  end

  def show
    @places = Place.mine(current_user).not_gone.
      order('updated_at DESC').pluck(:name, :id)
    @travel = Travel.schedules.belong(current_user).find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.ics { render text: @travel.to_ics }
    end
  end

  def new
    @travel = Travel.new
  end

  def edit
    members = @travel.members - [@travel.owner_id]
    @members = User.find(members)
  end

  def create
    @travel = Travel.build(travel_params, current_user)

    if @travel.save
      flash[:info] = '旅行の予定を作成しました'
      redirect_to travel_path(@travel)
    else
      render :new
    end
  end

  def update
    if @travel.update(travel_params)
      flash[:info] = '旅行の予定を更新しました'
      redirect_to @travel
    else
      render :edit
    end
  end

  def destroy
    @travel.destroy
    flash[:info] = '旅行の予定を削除しました'
    redirect_to travels_url
  end

  private
    def set_travel
      @travel = Travel.belong(current_user).find(params[:id])
    end

    def set_travel_by_owner
      @travel = Travel.mine(current_user).find(params[:id])
    end

    def travel_params
      params.require(:travel).permit(:name, :memo, :start_date, :end_date, :user_id)
    end
end
