class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :book_format
      t.integer :pages
      t.string :publisher
      t.date :publish_date
      t.string :isbn
      t.string :img_path
      t.decimal :score

      t.timestamps
    end
  end
end
