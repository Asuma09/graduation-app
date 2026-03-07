class CreateData < ActiveRecord::Migration[8.0]
  def change
    create_table :data do |t|
      t.string :type
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.date :event_date
      t.integer :parent_id

      t.timestamps
    end
  end
end
