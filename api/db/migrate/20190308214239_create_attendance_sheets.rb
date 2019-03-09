class CreateAttendanceSheets < ActiveRecord::Migration[5.2]
  def change
    create_table :attendance_sheets do |t|
      t.references :lecture_instance, foreign_key: true

      t.timestamps
    end
  end
end
