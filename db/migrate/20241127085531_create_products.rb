class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :slug
      t.references :product_details, polymorphic: true, null: false
      t.string :title
      t.text :description
      t.decimal :price

      t.timestamps
    end
    add_index :products, :slug
  end
end
