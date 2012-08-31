class CreateTiles < ActiveRecord::Migration
  def change
    create_table :tiles do |t|
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
