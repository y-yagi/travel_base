class TravelPhotosController < ApplicationController
  before_action :set_travel_photo, only: [:show, :edit, :update, :destroy]

  def new
    @photo_service_user_info = current_user.photo_service_user_info
    unless @photo_service_user_info
      return redirect_to edit_user_path(current_user), info: '写真サービスの設定を実施して下さい'
    end

    setup_album_list(@photo_service_user_info)

    @travel = Travel.mine(current_user).find(params[:travel_id])
    @travel_photo = @travel.travel_photos.build do |f|
      f.photo_service_user_info_id = @photo_service_user_info.id
    end
  end

  def show
    @need_pages_js = true
    return redirect_to root_path unless @travel_photo.travel.member?(current_user.id)
    client = PhotoServiceInfoWrapper.get_client(@travel_photo.photo_service_user_info)
    album_list = client.album.list
    @album = album_list.entries.find { |e| e.id == @travel_photo.photo_service_album_id }
    @photos = client.album.show(@album.id).entries
  end

  def create
    @photo_service_user_info = current_user.photo_service_user_info
    setup_album_list(@photo_service_user_info)
    @travel_photo = TravelPhoto.new(travel_photo_params)
    if @travel_photo.save
      redirect_to @travel_photo.travel, info: '写真データを紐付けしました'
    else
      render :new
    end
  end

  def destroy
    @travel_photo.destroy
    redirect_to @travel_photo.travel, info: '写真データの紐付けを削除しました'
  end

  private
    def set_travel_photo
      @travel_photo = TravelPhoto.find(params[:id])
    end

    def travel_photo_params
      params.require(:travel_photo).permit(:travel_id, :photo_service_user_info_id, :photo_service_album_id, :name)
    end

    def setup_album_list(photo_service_user_info)
      client = PhotoServiceInfoWrapper.get_client(photo_service_user_info)
      entries = client.album.list.entries
      @album_list = entries.map { |a| [a.name, a.id] }
    end
end
