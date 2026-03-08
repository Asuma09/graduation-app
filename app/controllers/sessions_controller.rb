class SessionsController < ApplicationController
skip_before_action :require_login
  def new
    # ログイン画面を表示するだけなので、ここは空っぽでOKです
  end

  def create
    # params[:custom_id] でユーザーを探す
    user = User.find_by(custom_id: params[:custom_id])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "ログインしました！"
    else
      flash.now[:alert] = "学籍番号、またはパスワードが間違っています"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # ログアウト：セッションからユーザーIDを削除する
    session.delete(:user_id)
    redirect_to login_path, notice: "\u30ED\u30B0\u30A2\u30A6\u30C8\u3057\u307E\u3057\u305F"
  end
end
