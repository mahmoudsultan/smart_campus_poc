class CreateKlassTopicMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :klass_topic_maps do |t|
      t.references :klass, foreign_key: true
      t.string :topic

      t.timestamps
    end
  end
end
