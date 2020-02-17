class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.belongs_to :user
      t.text :ticker
      t.float :price
      t.integer :quantity
      t.timestamps
    end
  end
end
