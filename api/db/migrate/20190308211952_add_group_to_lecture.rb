class AddGroupToLecture < ActiveRecord::Migration[5.2]
  def change
    add_reference :lectures, :group, foreign_key: true
  end
end
