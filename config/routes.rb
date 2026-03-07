Rails.application.routes.draw do
  
 # 新規登録画面を表示する (GET)
  get  "/signup", to: "users#new"
  # 新規登録を実行してデータベースに保存する (POST)
  post "/signup", to: "users#create"
  
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
