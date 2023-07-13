class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.string :schedule_name, null: false
      t.date :start_date
      t.date :end_date
      t.string :venue
      t.string :lodging
      t.text :memo
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :inventory_list, index: true, foreign_key: true
      t.belongs_to :purchase_list, index: true, foreign_key: true

      t.timestamps
    end
  end
end
