# Model for all tile images
class Tile < ActiveRecord::Base

  #Public: Makes a new tile.
  #
  # description   - the description of the tile
  # image         - the server relative path of the image
  # creation_date - the date this tile was created
  #
  # Returns the tile it has created
  def self.manufacture(description, image, creation_date=nil)
    tile = Tile.new
    tile.description = remove_uris(description)
    tile.image = image
    tile.image_md5 = ImageManager.get_md5("public/#{image}")
    tile.save
    tile.created_at = creation_date unless creation_date == nil
    tile.save
    return tile
  end
  URI_REGEX = %r"((?:(?:[^ :/?#]+):)(?://(?:[^ /?#]*))(?:[^ ?#]*)(?:\?(?:[^ #]*))?(?:#(?:[^ ]*))?)"

  def self.remove_uris(text)
    text.split(URI_REGEX).collect do |s|
      unless s =~ URI_REGEX
        s
      end
    end.join
  end
end
