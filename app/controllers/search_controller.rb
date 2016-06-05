class SearchController < ApplicationController
  def index
    return if params[:search].empty?
    @places = current_user.places.ransack({ name_or_address_or_memo_cont: params[:search]}).result
  end
end
