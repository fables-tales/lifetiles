require "images"

# All the juicy application logic lives in this class
class HomeController < ApplicationController
  def self.map_tile(tile, i)
      hash = {:id => i,
              :description => tile.description,
              :image => tile.image
             }
      hash[:bigimg] = tile.big_image     unless tile.big_image == nil
      hash[:loc] = [tile.lat, tile.long] unless tile.lat == nil
      return hash
  end

  def index
    tiles = Tile.order("created_at")
    id = params[:id]
    t = []
    i = 1
    tiles.each do |tile|
      hash = HomeController.map_tile tile, i
      t << hash
      i += 1
    end
    render :text => t.to_json
  end

  def post_image
    description  = params[:description]
    imageurl     = params[:image]
    logger.debug imageurl
    localPath    = ImageManager.acquire(imageurl)
    md5          = ImageManager.get_md5("public/images/#{localPath}")

    if Tile.where("image_md5 = ?", md5).length == 0
      Tile.manufacture description, "images/#{localPath}"
    end

    render :text => "success :)"

  end

end
