# frozen_string_literal: true

class CreateLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :lectures do |t|
      t.integer :start_timeslot
      t.integer :end_timeslot
      t.integer :day
      t.references :course_offering, foreign_key: true

      t.timestamps
    end
  end
end
