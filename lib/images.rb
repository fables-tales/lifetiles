require "singleton"
require "twitter"
require "http"
require 'digest/md5'

class ImageManager

  def self.get_image(url, path)
    result = Http.get url
    handle = open(path, "wb")
    handle.write(result)
    handle.close()
  end

  def self.twitter_profile(username)
    url = Twitter.user(username)[:profile_image_url].gsub("_normal", "")
    extension = url[-4..-1]
    filename = "#{Random.rand(1000000000)}#{extension}"

    ImageManager.get_image(url, "public/images/#{filename}")
    return filename
  end

  def self.resize_image(path)
    img = (Magick::Image.read path)[0]
    thumb = img.resize_to_fill(200, 200)
    thumb.write path
  end

  def self.get_md5(path)
    Digest::MD5.hexdigest(File.read(path))
  end

end
