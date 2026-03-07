class SessionsController < ApplicationController
skip_before_action :require_login
  def new
    # ログイン画面を表示するだけなので、ここは空っぽでOKです
  end

  def create
    # 1. 送られてきた学籍番号(custom_id)でユーザーをデータベースから探す
    user = User.find_by(custom_id: params[:session][:custom_id])

    # 2. ユーザーが存在し、かつパスワードが正しいか確認する
    # (authenticate は has_secure_password が用意してくれる便利なメソッドです！)
    if user && user.authenticate(params[:session][:password])
      # ログイン成功：ブラウザのセッション（記憶領域）にユーザーIDを保存する
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました！' # ※root_path(トップページ)は後で設定します
    else
      # ログイン失敗：エラーメッセージを表示してログイン画面に戻す
      flash.now[:alert] = '学籍番号またはパスワードが間違っています'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # ログアウト：セッションからユーザーIDを削除する
    session.delete(:user_id)
    redirect_to login_path, notice: 'ログアウトしました'
  end
end