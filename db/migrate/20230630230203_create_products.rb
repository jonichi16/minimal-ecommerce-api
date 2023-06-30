class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.decimal :price, precision: 8, scale: 2, default: 0.00
      t.integer :quantity

      t.timestamps
    end
  end
end
