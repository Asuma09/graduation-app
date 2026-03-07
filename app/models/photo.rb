class Photo < Datum
  # Photoは1つの画像ファイル（imageという名前）を持つ、という宣言
  has_one_attached :image
end
