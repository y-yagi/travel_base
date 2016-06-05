class SearchController < ApplicationController
  def index
    @places = if params[:search].blank?
      []
    else
      current_user.places.ransack({ name_or_address_or_memo_cont: params[:search]}).result
    end
  end
end
