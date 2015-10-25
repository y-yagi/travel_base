class DropboxFilesController < ApplicationController
  def destroy
    travel = Travel.belong(current_user).find(params[:travel_id])
    DropboxFile.find_by(travel_id: travel.id, id: params[:id]).destroy!
    redirect_to edit_travel_url(travel), info: 'ファイルを削除しました'
  end
end
