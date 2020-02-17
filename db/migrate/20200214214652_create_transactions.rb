class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :user
      t.text :status
      t.text :ticker
      t.float :price
      t.string :quantity
      t.timestamps
    end
  end
end
