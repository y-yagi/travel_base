class TravelsController < ApplicationController
  before_action :set_travel, only: [:edit_photo]
  before_action :set_travel_by_owner, only: [:edit, :update, :destroy]
  before_action :set_page_js, only: [:new, :show, :edit, :update]

  def index
    @travels = Travel.belong(current_user).order('start_date DESC').page(params[:page])
  end

  def show
    @places = current_user.places.not_gone.
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
      redirect_to travel_path(@travel), info: '旅行の予定を作成しました'
    else
      render :new
    end
  end

  def update
    if @travel.update(travel_params)
      redirect_to edit_travel_path(@travel), info: '旅行の予定を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @travel.destroy
    redirect_to travels_url, info: '旅行の予定を削除しました'
  end

  private
    def set_travel
      @travel = Travel.belong(current_user).find(params[:id])
    end

    def set_travel_by_owner
      @travel = Travel.mine(current_user).find(params[:id])
    end

    def travel_params
      params.require(:travel).permit(
        :name, :memo, :start_date, :end_date, :user_id,
        dropbox_files_attributes: [:id, :name, :url]
      )
    end
end
