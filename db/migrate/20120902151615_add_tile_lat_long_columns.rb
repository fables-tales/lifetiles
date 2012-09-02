class AddTileLatLongColumns < ActiveRecord::Migration
  def up
    add_column :tiles, :lat, :float
    add_column :tiles, :long, :float
  end

  def down
    remove_column :tiles, :lat
    remove_column :tiles, :long
  end
end
