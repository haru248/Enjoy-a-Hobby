class CreatePropertyCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :property_categories do |t|
      t.string :category_name, null: false
      t.belongs_to :inventory_list, index: true, foreign_key: true

      t.timestamps
    end
    add_index :property_categories, [:category_name, :inventory_list_id], unique: true
  end
end
