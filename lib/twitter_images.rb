require "images"

class Twitter::Tweet
  def has_media?
    not self[:media].empty?
  end
end

class TwitterTileGenerator
  def self.tile_from_tweet(tweet)
      media = tweet.media.first
      url = media.attrs[:media_url]
      ext = url[-4..-1]
      name = "#{Random.rand(10000000)}#{ext}"
      path = "public/images/#{name}"
      ImageManager.get_image(url, path)
      ImageManager.resize_image(path)
      md5 = ImageManager.get_md5(path)
      if Tile.where("image_md5 = ?", md5).empty?
        Tile.manufacture(tweet.text, "images/#{name}", tweet[:created_at])
      end
  end
  def self.make_tiles(user)
    tweets = Twitter.user_timeline(user, options = {:include_entities => true,
                                                    :count => 200})
    tweets.each do |tweet|
      if tweet.has_media?
        self.tile_from_tweet tweet
      end
    end
  end
end
