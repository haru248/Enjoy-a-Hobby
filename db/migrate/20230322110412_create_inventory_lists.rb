class CreateInventoryLists < ActiveRecord::Migration[6.1]
  def change
    create_table :inventory_lists do |t|
      t.string :inventory_list_name, null: false
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
