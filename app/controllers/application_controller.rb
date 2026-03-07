class ApplicationController < ActionController::Base
  # どの画面（ビュー）からでも current_user を使えるようにする魔法の記述です
  helper_method :current_user

  private

  # セッション（記憶）にある user_id をもとに、データベースからユーザーを探し出す処理
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
