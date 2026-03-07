class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :custom_id
      t.string :password_digest
      t.string :nickname
      t.string :theme_color

      t.timestamps
    end
  end
end
