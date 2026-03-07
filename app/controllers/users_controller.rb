class UsersController < ApplicationController
  def new
    # 画面（ビュー）に渡すための、空っぽのユーザー情報を用意します
    @user = User.new
  end

  def create
    # 入力されたデータ（user_params）を使って、新しいユーザーを作成します
    @user = User.new(user_params)
    
    if @user.save
      # 保存に成功した場合：そのまま自動でログイン状態にして、トップページへ移動
      session[:user_id] = @user.id
      redirect_to root_path, notice: "ユーザー登録が完了しました！"
    else
      # 保存に失敗した場合（学籍番号のルール違反など）：もう一度登録画面を表示してエラーを教える
      render :new, status: :unprocessable_entity
    end
  end

  private

  # セキュリティ対策（Strong Parameters）
  # 悪意のあるデータが送られてこないように、許可した項目のデータだけを受け取るためのルールです
  def user_params
    params.require(:user).permit(:custom_id, :email, :password, :password_confirmation, :nickname, :theme_color)
  end
end
