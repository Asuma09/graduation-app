Rails.application.routes.draw do
  # ログイン画面を表示する (GET)
  get    '/login',   to: 'sessions#new'
  
  # ログインを実行する (POST)
  post   '/login',   to: 'sessions#create'
  
  # ログアウトを実行する (DELETE)
  delete '/logout',  to: 'sessions#destroy'
end
