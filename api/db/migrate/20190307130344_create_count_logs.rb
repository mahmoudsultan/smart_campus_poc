# frozen_string_literal: true

class CreateCountLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :count_logs do |t|
      t.datetime :date
      t.integer :count
      t.references :klass, foreign_key: true

      t.timestamps
    end
  end
end
