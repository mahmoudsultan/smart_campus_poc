class CreateFaceBoxes < ActiveRecord::Migration[5.2]
  def change
    create_table :face_boxes do |t|
      t.integer :state
      t.string :boundaries

      t.timestamps
    end
  end
end
