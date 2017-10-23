class SearchController < ApplicationController
  def index
    return if params[:search].empty?
    @places = current_user.places.search(params[:search])
  end
end
