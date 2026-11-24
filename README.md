# 思い出アルバム（graduation-app / memory-app）

卒業の記念に、同じゼミのメンバーで**写真と投稿を残していく**アプリ。投稿にも写真にも「いいね」「コメント」「返信」が付き、匿名でメッセージを送る機能もある。**チーム制作**（機能ごとに担当を分けて実装）。

**Ruby on Rails 8.0.4 / PostgreSQL / Active Storage + S3 / bcrypt / Render（PWA 対応）**

---

## 設計上の工夫

### 投稿と写真を1つのテーブルにまとめる（STI）

「文章の投稿」と「写真の投稿」は、見た目は違うが**いいね・コメント・返信の仕組みは完全に同じ**。別テーブルにすると、いいね機能を2回実装することになる。

そこで **STI（Single Table Inheritance）** で共通の親に寄せた。

```ruby
class Post < Datum; end

class Photo < Datum
  has_one_attached :image
end
```

写真だけが画像の添付を持ち、それ以外は親の `Datum` が持つ。

### 返信を自己参照で表現する

コメントへの返信も同じ `Datum` として扱い、親子関係を自分自身への参照で持たせている。

```ruby
class Datum < ApplicationRecord
  belongs_to :parent, class_name: "Datum", optional: true
  has_many :replies, foreign_key: :parent_id
  has_many :likes
end
```

`optional: true` にしてあるので、親を持たないレコード（＝トップレベルの投稿）と返信を同じテーブルで表せる。スレッド構造の深さに制限を持たない設計になった。

いいねの判定はモデルのメソッドに閉じ込め、ビューから状態を組み立てないようにしている。

```ruby
def liked_by?(user)
  likes.exists?(user_id: user.id)
end
```

### 学籍番号を実際の形式で検証する

ユーザー登録は `has_secure_password`（bcrypt）で、パスワードを平文で持たない。加えて、学籍番号は**大学で実際に使われている形式**に合わせて検証している。

```ruby
/\A\d{2}[lsebjp]\d{4}\z/
```

学部を表す1文字を含む形式なので、桁数チェックだけでなく文字種まで絞った。身内向けのアプリなので、無関係な第三者が登録しにくくする意図もある。

### 匿名メッセージ

`SecretMessage` として、送信者を表示せずにメッセージを残せる機能を分けて持っている。通常の投稿とは別モデルにし、いいね・コメントの対象にならないようにした。

## チーム制作とデプロイ

機能ごとに担当を分けて進めた。ルーティングにも担当範囲のコメントが残っている。

```ruby
# --- Aさんが担当しているログイン機能のルーティング ---
```

### Render でのデプロイで詰まった点

マイグレーションの実行タイミングで `PG::ConnectionBad` が出た。原因は**ビルド時点ではまだ DB に接続できない**ことで、`db:migrate` の実行場所を

```
buildCommand → startCommand → preDeployCommand
```

と移して解決した。`preDeployCommand` はデプロイ直前かつ DB 接続が確立した状態で動くため、ここが正しい置き場所だった。

併せて、Solid Cache / Solid Queue / Solid Cable 用のテーブルが作られていなかったため手動のマイグレーションで補い、`DATABASE_URL` のパースも修正している。一連の試行はコミット履歴（全80コミット）にそのまま残してある。

### PWA

`manifest.json.erb` と `service-worker.js` を置き、スマートフォンのホーム画面から開けるようにしている。

## 構成

```
app/
├── models/
│   ├── datum.rb           # 親クラス（parent / replies / likes）
│   ├── post.rb            # STI: 文章の投稿
│   ├── photo.rb           # STI: 写真の投稿（has_one_attached）
│   ├── user.rb            # has_secure_password / 学籍番号の検証
│   ├── like.rb
│   └── secret_message.rb  # 匿名メッセージ
├── controllers/
└── views/ (pwa/manifest.json.erb, service-worker.js を含む)
render.yaml                # preDeployCommand で db:migrate
```

## セットアップ

```bash
bundle install
rails db:create db:migrate
rails s
```

## 制約

- 身内のゼミメンバー向けに作っており、公開運用を想定した権限管理やモデレーション機能はない
- 匿名メッセージは送信者を記録しない設計のため、不適切な投稿の追跡ができない
- 短期間のチーム制作のため、テストは書いていない
