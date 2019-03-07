class AddKlassToLecture < ActiveRecord::Migration[5.2]
  def change
    add_reference :lectures, :klass, foreign_key: true
  end
end
