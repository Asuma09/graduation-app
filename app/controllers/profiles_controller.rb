class ProfilesController < ApplicationController
  def edit
    # 常に「今ログインしている自分」を編集対象にする
    @user = current_user
  end

  def update
    @user = current_user
    # もし更新に成功したら、同じ画面にスッと戻る
    if @user.update(user_params)
      redirect_to edit_profile_path, notice: "プロフィールを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # ニックネーム、アイコン画像、そしてテーマカラーの変更を許可する
    params.require(:user).permit(:nickname, :avatar, :theme_color)
  end
end
