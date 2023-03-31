class CreatePurchaseLists < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_lists do |t|
      t.string :purchase_list_name, null: false
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
