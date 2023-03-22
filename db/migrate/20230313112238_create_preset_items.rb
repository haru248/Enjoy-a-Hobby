class CreatePresetItems < ActiveRecord::Migration[6.1]
  def change
    create_table :preset_items do |t|
      t.string :preset_item_name, null: false
      t.belongs_to :item_category, index: true, foreign_key: true

      t.timestamps
    end
  end
end
