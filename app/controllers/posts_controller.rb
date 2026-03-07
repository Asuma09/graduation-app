class PostsController < ApplicationController
  def index
    # データベースから「Post（思い出）」をすべて取得し、新しい順（desc）に並べて @posts という変数に入れる
    @posts = Post.all.order(created_at: :desc)
  end

  def new
  end

  def create
  end

  def show
  end
end
