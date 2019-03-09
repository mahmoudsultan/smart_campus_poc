# frozen_string_literal: true

class AddKlassToKlassRequests < ActiveRecord::Migration[5.2]
  def change
    add_reference :klass_requests, :klass, foreign_key: true
  end
end
