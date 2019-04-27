# frozen_string_literal: true

class CreateLectureInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :lecture_instances do |t|
      t.integer :week_number
      t.datetime :date
      t.references :lecture, foreign_key: true

      t.timestamps
    end
  end
end
