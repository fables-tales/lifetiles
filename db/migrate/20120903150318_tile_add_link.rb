class TileAddLink < ActiveRecord::Migration
  def up
    add_column :tiles, :link, :string
  end

  def down
    remove_column :tile, :link
  end
end
