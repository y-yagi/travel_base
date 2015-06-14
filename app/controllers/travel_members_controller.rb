class TravelMembersController < ApplicationController
  def new
    travel = Travel.find(params[:travel_id])
    return redirect_to root_url unless travel.valid_invite_key?(params[:key])

    travel.update!(members: (travel.members << current_user.id).uniq)
    flash[:info] = '旅行に参加しました'
    redirect_to travel_url(travel)
  end

  def destroy
    travel = Travel.belong(current_user).find(params[:travel_id])
    travel.update!(members: travel.members - [params[:id].to_i])
    flash[:info] = 'メンバーを削除しました'
    redirect_to edit_travel_url(travel)
  end
end
