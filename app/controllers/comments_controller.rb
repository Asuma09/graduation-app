class CommentsController < ApplicationController
  def create
    # コメントされた投稿（PostかPhoto）を探して、新しいコメントを保存する
    datum = Datum.find(params[:datum_id])
    Comment.create(user: current_user, datum: datum, content: params[:content])

    # 元の画面（一覧画面）にそのまま戻る
    redirect_back(fallback_location: root_path)
  end
end
