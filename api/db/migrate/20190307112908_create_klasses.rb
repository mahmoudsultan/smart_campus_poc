# frozen_string_literal: true

class CreateKlasses < ActiveRecord::Migration[5.2]
  def change
    create_table :klasses do |t|
      t.string :name
      t.string :floor
      t.integer :capacity
      t.boolean :projector
      t.references :building, foreign_key: true

      t.timestamps
    end
  end
end
