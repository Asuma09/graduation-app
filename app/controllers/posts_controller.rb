class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    @post.user = current_user

    if @post.save
      redirect_to posts_path, notice: "思い出を投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # --- ここから下を追加・書き換え ---

  def show
    # 今回はまだ使いませんが、後で作ります！
  end

  def edit
    # URLの番号（id）から、編集したい特定の思い出を探してくる
    @post = Post.find(params[:id])
  end

  def update
    # 編集したい思い出を探してきて、新しいデータで上書き保存する
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, notice: "思い出を更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # 削除したい思い出を探してきて、データベースから消し去る
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "思い出を削除しました！"
  end

  # --- ここまで ---

  private

  def post_params
    params.require(:post).permit(:content, :event_date)
  end
end
