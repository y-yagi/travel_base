class PhotosController < ApplicationController
  def index
    # TODO: user
    client = PhotoServiceInfoWrapper.get_client(PhotoServiceUserInfo.first)
    album_list = client.album.list
    @album = album_list.entries.first
    @photos = client.album.show(@album.id).entries
  end
end
