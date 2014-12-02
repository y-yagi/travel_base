class TravelPhotosController < ApplicationController
  before_action :set_travel_photo, only: [:show, :edit, :update, :destroy]

  def index
    @travel_photos = TravelPhoto.all
  end

  def show
    # TODO: user
    client = PhotoServiceInfoWrapper.get_client(@travel_photo.photo_service_user_info)
    album_list = client.album.list
    @album = album_list.entries.find { |e| e.id == @travel_photo.photo_service_album_id }
    @photos = client.album.show(@album.id).entries
  end

  def new
    @travel_photo = TravelPhoto.new
  end

  # GET /travel_photos/1/edit
  def edit
  end

  # POST /travel_photos
  # POST /travel_photos.json
  def create
    @travel_photo = TravelPhoto.new(travel_photo_params)

    respond_to do |format|
      if @travel_photo.save
        format.html { redirect_to @travel_photo, notice: 'Travel photo was successfully created.' }
        format.json { render :show, status: :created, location: @travel_photo }
      else
        format.html { render :new }
        format.json { render json: @travel_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /travel_photos/1
  # PATCH/PUT /travel_photos/1.json
  def update
    respond_to do |format|
      if @travel_photo.update(travel_photo_params)
        format.html { redirect_to @travel_photo, notice: 'Travel photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @travel_photo }
      else
        format.html { render :edit }
        format.json { render json: @travel_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /travel_photos/1
  # DELETE /travel_photos/1.json
  def destroy
    @travel_photo.destroy
    respond_to do |format|
      format.html { redirect_to travel_photos_url, notice: 'Travel photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_travel_photo
      @travel_photo = TravelPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def travel_photo_params
      params.require(:travel_photo).permit(:travel_id, :photo_service_user_info_id, :photo_service_album_id, :name)
    end
end
