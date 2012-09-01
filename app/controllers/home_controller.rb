require "images"

class HomeController < ApplicationController
  def index
    tiles = Tile.order("created_at")
    id = params[:id]
    t = []
    i = 1
    tiles.each do |tile|
      t << {:id => i,
            :description => tile.description,
            :image => tile.image}
      i += 1
    end
    render :text => t.to_json
  end

  def post_image
    description  = params[:description]
    imageurl     = params[:image]
    logger.debug imageurl
    localPath    = ImageManager.acquire(imageurl, logger)
    md5          = ImageManager.get_md5("public/images/#{localPath}")
    if Tile.where("image_md5 = ?", md5).length == 0
      t = Tile.new
      t.description = description
      t.image       = "images/#{localPath}"
      t.image_md5   = md5
      t.save
    end

    render :text => "success :)"

  end

end
