class CreatePurchases < ActiveRecord::Migration[6.1]
  def change
    create_table :purchases do |t|
      t.string :purchase_name, null: false
      t.integer :price, null: false
      t.integer :quantity, null: false
      t.belongs_to :purchase_list, index: true, foreign_key: true

      t.timestamps
    end
  end
end
