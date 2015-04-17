class SearchController < ApplicationController
  def index
    @places = Place.search_by(params[:search], current_user, page: params[:page], per: 9)
  end
end
