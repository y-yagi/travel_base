class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_page_js, only: [:new, :show, :edit, :update]

  def edit
    @user.build_photo_service_user_info unless @user.photo_service_user_info
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), info: 'ユーザ情報の更新が完了しました'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to login_url, info: 'ユーザ情報の削除が完了しました'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :uid, :provider, :name, :email, :deleted_at, :auto_archive,
        photo_service_user_info_attributes: [ :service_type, :photo_service_user_id, :user_id ]
      )
    end
end
