class CreateItemCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :item_categories do |t|
      t.string :item_category_name, null: false
      t.belongs_to :preset, index: true, foreign_key: true

      t.timestamps
    end
    add_index :item_categories, [:item_category_name, :preset_id], unique: true
  end
end
