# frozen_string_literal: true

class CreateActivityLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_logs do |t|
      t.datetime :date
      t.integer :state
      t.references :klass, foreign_key: true

      t.timestamps
    end
  end
end
