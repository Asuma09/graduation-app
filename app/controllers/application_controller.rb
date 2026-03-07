class ApplicationController < ActionController::Base
  helper_method :current_user

  # ▼追加：すべてのアクション（画面表示や保存処理）の前に、必ず require_login を実行する
  before_action :require_login

  private

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ▼追加：警備員のお仕事内容（ログインしていなければ、ログイン画面へ強制送還）
  def require_login
    unless current_user
      flash[:alert] = "ログインしてください"
      redirect_to login_path
    end
  end
end
