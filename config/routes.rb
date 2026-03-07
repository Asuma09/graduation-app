Rails.application.routes.draw do
  # 投稿（Post）に関する標準的なURL（一覧、詳細、作成など）を自動で一気に設定する魔法のコード
  resources :posts, only: [ :index, :new, :create, :show ]

  # アプリのトップページ（http://localhost:3000/）にアクセスしたとき、
  # 自動的にPostsのindex（一覧画面）が表示されるようにする設定
  root "posts#index"
  # ログイン画面を表示する (GET)
  get    "/login",   to: "sessions#new"

  # ログインを実行する (POST)
  post   "/login",   to: "sessions#create"

  # ログアウトを実行する (DELETE)
  delete "/logout",  to: "sessions#destroy"
end
