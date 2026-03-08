class LikesController < ApplicationController
  def create
    # いいねされた投稿（PostかPhoto）を探して、ログイン中のユーザーの「いいね」として保存する
    datum = Datum.find(params[:id])
    Like.create(user: current_user, datum: datum)

    # 魔法のメソッド：いいねを押した「元の画面（一覧画面）」にそのまま戻る
    redirect_back(fallback_location: root_path)
  end

  def destroy
    # いいねを取り消す処理
    datum = Datum.find(params[:id])
    like = Like.find_by(user: current_user, datum: datum)
    like.destroy

    # こちらも元の画面に戻る
    redirect_back(fallback_location: root_path)
  end
end
