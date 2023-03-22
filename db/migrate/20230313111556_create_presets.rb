class CreatePresets < ActiveRecord::Migration[6.1]
  def change
    create_table :presets do |t|
      t.string :preset_name, null: false
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
