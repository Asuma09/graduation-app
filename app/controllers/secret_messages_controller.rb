class SecretMessagesController < ApplicationController
  before_action :require_login # ApplicationControllerにすでに定義されている想定
  before_action :ensure_graduate, only: [ :index ]
  before_action :ensure_undergraduate, only: [ :create ]

  def index
    # 卒業生のみが全メッセージを閲覧できる
    @secret_messages = SecretMessage.all.order(created_at: :desc)
  end

  def create
    # 在校生から送られたメッセージを保存する
    @secret_message = current_user.secret_messages.build(secret_message_params)

    if @secret_message.save
      redirect_to posts_path, notice: "先輩に秘密のメッセージを送りました！🤫"
    else
      redirect_to posts_path, alert: "メッセージの送信に失敗しました"
    end
  end

  private

  def secret_message_params
    params.require(:secret_message).permit(:content)
  end

  # 卒業生（21, 22始まり）かどうかをチェック
  def ensure_graduate
    unless current_user.custom_id.start_with?("21", "22")
      redirect_to posts_path, alert: "この部屋には卒業生しか入れません！"
    end
  end

  # 在校生（21, 22以外）かどうかをチェック
  def ensure_undergraduate
    if current_user.custom_id.start_with?("21", "22")
      redirect_to posts_path, alert: "卒業生はメッセージを送信できません！"
    end
  end
end
