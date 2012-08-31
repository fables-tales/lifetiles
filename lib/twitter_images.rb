require "images"
class TwitterTileGenerator
  def self.make_tiles(user)
    tweets = Twitter.user_timeline(user, options = {:include_entities => true,
                                                    :count => 200})
    tweets.each do |t|
      if t.media != []
        media = t.media.first
        url = media.attrs[:media_url]
        ext = url[-4..-1]
        name = "#{Random.rand(10000000)}#{ext}"
        path = "public/images/#{name}"
        ImageManager.get_image(url, path)
        ImageManager.resize_image(path)
        md5 = ImageManager.get_md5(path)
        if Tile.where("image_md5 = ?", md5).length == 0
          tile = Tile.new
          tile.description = t.text
          tile.image = "images/#{name}"
          tile.image_md5 = ImageManager.get_md5(path)
          tile.save
          tile.created_at = t[:created_at]
          tile.save
        end
      end
    end
  end
end
