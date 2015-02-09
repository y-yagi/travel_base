class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def edit
    @user.build_photo_service_user_info unless @user.photo_service_user_info
  end

  def update
    if @user.update(user_params)
      flash[:info] = 'ユーザ情報の更新が完了しました'
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:info] = 'ユーザの削除が完了しました'
    redirect_to login_url
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :uid, :provider, :name, :email, :deleted_at,
        photo_service_user_info_attributes: [ :service_type, :photo_service_user_id, :user_id ]
      )
    end
end
