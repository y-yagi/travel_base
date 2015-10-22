class DropboxFilesController < ApplicationController
  def destroy
    travel = Travel.belong(current_user).find(params[:travel_id])
    travel.update!(members: travel.members - [params[:id].to_i])
    redirect_to edit_travel_url(travel), info: 'メンバーを削除しました'
  end
end
