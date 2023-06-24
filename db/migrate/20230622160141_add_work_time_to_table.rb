class AddWorkTimeToTable < ActiveRecord::Migration[7.0]
  def change
    add_column :work_hours, :work_time, :integer
  end
end
