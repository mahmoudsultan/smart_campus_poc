class AddImageToAttendanceSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :attendance_sheets, :image, :string
  end
end
