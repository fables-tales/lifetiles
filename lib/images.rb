require "singleton"
require "twitter"
require "http"
require 'digest/md5'
require "RMagick"

# Useful functions to get and create images
class ImageManager

  def self.get_image(url, path)
    result = Http.get url
    handle = open(path, "wb")
    handle.write(result)
    handle.flush()
    handle.close()
  end

  def self.acquire(url, big=false)
    extension = url[-4..-1]
    filename  = "#{Random.rand(10000000000)}#{extension}"
    path = "public/images/#{filename}"
    ImageManager.get_image(url, path)
    size = big ? :big : :small
    ImageManager.resize_image(path, size)
    return filename
  end

  def self.resize_image(path, size=:small)
    img = (Magick::Image.read path)[0]
    if size == :small
      thumb = img.resize_to_fill(200, 200)
    else
      thumb = img.resize_to_fill(700, 400)
    end
    thumb.write path
  end

  def self.twitter_profile(username)
    url = Twitter.user(username)[:profile_image_url].gsub("_normal", "")
    self.acquire(url)
  end

  def self.get_md5(path)
    Digest::MD5.hexdigest(File.read(path))
  end

end
