class User < ApplicationRecord
  # パスワードを暗号化して保存するためのRailsの便利機能
  has_secure_password

  has_many :data, dependent: :destroy

  # 学籍番号 (custom_id) のルール設定
  validates :custom_id, 
            presence: true,   # 空っぽでの登録を禁止
            uniqueness: true, # 他の人と同じ学籍番号での登録を禁止
            format: { 
              with: /\A\d{2}[lsebjp]\d{4}\z/, 
              message: "は「数字2桁＋指定の英字(l,s,e,b,j,p)＋数字4桁」の正しい形式で入力してください" 
            }

  # 追加したメールアドレス (email) のルール設定
  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
              message: "は正しいメールアドレスの形式で入力してください"
            }
end
