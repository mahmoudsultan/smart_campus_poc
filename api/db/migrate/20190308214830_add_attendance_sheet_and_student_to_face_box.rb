class AddAttendanceSheetAndStudentToFaceBox < ActiveRecord::Migration[5.2]
  def change
    add_reference :face_boxes, :attendance_sheet, foreign_key: true
    add_reference :face_boxes, :user, foreign_key: true
  end
end
