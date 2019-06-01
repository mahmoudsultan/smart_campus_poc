class CreateAvatars < ActiveRecord::Migration[5.2]
  def change
    create_table :avatars do |t|
      t.string :image
      t.references :user, foreign_key: true
      t.boolean :is_main
      
      t.timestamps
    end
  end
end
