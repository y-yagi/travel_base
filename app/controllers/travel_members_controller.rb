class TravelMembersController < ApplicationController
  def new
    travel = Travel.find(params[:travel_id])
    return redirect_to root_url unless travel.valid_invite_key?(params[:key])

    travel.update!(members: (travel.members << current_user.id).uniq)
    redirect_to travel_url(travel), info: '旅行に参加しました'
  end

  def destroy
    travel = Travel.belong(current_user).find(params[:travel_id])
    travel.update!(members: travel.members - [params[:id].to_i])
    redirect_to edit_travel_url(travel), info: 'メンバーを削除しました'
  end
end
