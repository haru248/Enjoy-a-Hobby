class CreateLiveTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :live_times do |t|
      t.date :live_date
      t.time :opening_time
      t.time :start_time
      t.belongs_to :schedule, index: true, foreign_key: true

      t.timestamps
    end
  end
end
