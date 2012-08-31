class AddImageMd5Column < ActiveRecord::Migration
  def up
    add_column :tiles, :image_md5, :string
  end

  def down
    remove_column :tiles, :image_md5
  end
end
