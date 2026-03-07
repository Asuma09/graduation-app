class PostsController < ApplicationController
  def index
    # データベースから「Post（思い出）」をすべて取得し、新しい順（desc）に並べて @posts という変数に入れる
    @posts = Post.all.order(created_at: :desc)
  end
  def new
    # 入力フォーム用の「空っぽの箱」を用意する
    @post = Post.new
  end

  def create
    # 送られてきたデータ（日付や内容）を使って新しい思い出を作る
    @post = Post.new(post_params)

    # ⚠️ チーム開発のポイント！
    # 今はAさんがログイン機能を開発中で「今ログインしている人」が誰かわからないため、
    # とりあえず仮で「データベースにいる1人目のユーザー」の投稿として保存します。
    @post.user = User.first

    if @post.save
      # 保存に成功したら、一覧画面（index）に戻る
      redirect_to posts_path, notice: "思い出を投稿しました！"
    else
      # 保存に失敗したら、もう一度入力フォーム（new）を表示する
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  # セキュリティ対策：フォームから送られてきていいデータ（contentとevent_date）だけを許可する「ストロングパラメーター」
  def post_params
    params.require(:post).permit(:content, :event_date)
  end
end
