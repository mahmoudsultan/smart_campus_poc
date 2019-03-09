class CreateAttendanceIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :attendance_issues do |t|
      t.references :user, foreign_key: true
      t.references :face_box, foreign_key: true
      t.references :attendance_sheet, foreign_key: true

      t.timestamps
    end
  end
end
