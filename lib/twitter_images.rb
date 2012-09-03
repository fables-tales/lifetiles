# Exernal tweet class, we patch a has_media? method onto it
class Twitter::Tweet
  def has_media?
    not self[:media].empty?
  end
end

# Class for generating tiles from twitter
class TwitterTileGenerator

  def self.handle_geo(tweet, tile)
    if tweet.geo != nil
      tile.lat = tweet.geo.coordinates[0]
      tile.long = tweet.geo.coordinates[1]
    end
  end

  def self.tile_from_tweet(tweet)
    return unless tweet.has_media?
    media = tweet.media.first
    url = media.attrs[:media_url]
    name = ImageManager.acquire(url)
    big  = ImageManager.acquire url, big=true
    path = "public/images/#{name}"
    md5 = ImageManager.get_md5(path)
    if Tile.where("image_md5 = ?", md5).empty?
      tile = Tile.manufacture(tweet.text, "images/#{name}", tweet[:created_at])
      tile.big_image = "images/#{big}"
      self.handle_geo(tweet, tile)
      tile.save
    end
  end

  def self.make_tiles(user)
    tweets = Twitter.user_timeline(user, options = {:include_entities => true,
                                                    :count => 200})
    tweets.each do |tweet|
      self.tile_from_tweet tweet
    end
  end
end
