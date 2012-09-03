class TileAddBigImageField < ActiveRecord::Migration
  def up
    add_column :tiles, :big_image, :string
  end

  def down
    remove_column :tiles, :big_image
  end
end
