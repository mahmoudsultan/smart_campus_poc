class AddStateToAttendanceIssue < ActiveRecord::Migration[5.2]
  def change
    add_column :attendance_issues, :state, :integer, default: 0
  end
end
