# frozen_string_literal: true

class CreateCourseOfferings < ActiveRecord::Migration[5.2]
  def change
    create_table :course_offerings do |t|
      t.integer :term
      t.integer :year
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
