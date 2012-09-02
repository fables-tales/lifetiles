class Tile < ActiveRecord::Base
  def self.manufacture(description, image, creation_date=nil)
    tile = Tile.new
    tile.description = description
    tile.image = image
    tile.image_md5 = ImageManager.get_md5("public/#{image}")
    tile.save
    tile.created_at = creation_date unless creation_date = nil
    tile.save
  end
end
