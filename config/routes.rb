Rails.application.routes.draw do
  # 投稿（Post）に関する標準的なURL（一覧、詳細、作成、編集、更新、削除）をすべて有効化
  resources :posts
  resources :photos

  post   "like/:id", to: "likes#create", as: "create_like"
  delete "like/:id", to: "likes#destroy", as: "destroy_like"

  # アプリのトップページ（http://localhost:3000/）を一覧画面に設定
  root "posts#index"

  # --- Aさんが担当しているログイン機能のルーティング ---
  get    "/signup",  to: "users#new"
  post   "/signup",  to: "users#create"
  # ログイン画面を表示する（GET）
  get    "/login",   to: "sessions#new"

  # ログインを実行する（POST）
  post   "/login",   to: "sessions#create"

  # ログアウトを実行する（DELETE）
  delete "/logout",  to: "sessions#destroy"

  # -----------------------------------------------
end
