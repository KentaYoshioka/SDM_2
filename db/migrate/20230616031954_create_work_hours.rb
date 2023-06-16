class CreateWorkHours < ActiveRecord::Migration[7.0]
  def change
    create_table :work_hours do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :assignment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
