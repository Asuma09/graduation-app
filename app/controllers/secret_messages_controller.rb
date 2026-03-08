class SecretMessagesController < ApplicationController
  def index
    # 【超重要】ここで卒業生（21, 22始まり）かどうかをチェック！
    # もし卒業生「じゃなかったら（unless）」トップページに追い出すガードマンです
    unless current_user.custom_id.start_with?("21", "22")
      redirect_to root_path, alert: "ここは卒業生だけの秘密の部屋です🤫 在校生は入れません！"
      return
    end
    
    # ガードを突破した（＝卒業生だった）場合のみ、全メッセージを取得して表示！
    @secret_messages = SecretMessage.all.order(created_at: :desc)
  end

  def create
    # 在校生がフォームから送ってきたメッセージを保存する処理
    @secret_message = SecretMessage.new(secret_message_params)
    @secret_message.user = current_user

    if @secret_message.save
      redirect_to root_path, notice: "卒業生へのサプライズメッセージをこっそり送信しました！🤫✨"
    else
      redirect_to root_path, alert: "メッセージの送信に失敗しました💦"
    end
  end

  private

  # 安全のためのStrong Parameters（メッセージの文章だけを許可）
  def secret_message_params
    params.require(:secret_message).permit(:content)
  end
end