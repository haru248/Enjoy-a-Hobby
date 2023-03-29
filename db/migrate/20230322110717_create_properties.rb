class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :property_name, null: false
      t.belongs_to :property_category, index: true, foreign_key: true

      t.timestamps
    end
  end
end
