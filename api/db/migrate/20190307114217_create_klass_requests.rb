# frozen_string_literal: true

class CreateKlassRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :klass_requests do |t|
      t.integer :required_capacity
      t.boolean :projector
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
